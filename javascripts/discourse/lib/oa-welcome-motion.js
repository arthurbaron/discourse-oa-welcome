import { modifier } from "ember-modifier";

// Keep in sync with the sticky-stack media query in common/common.scss.
const STACKING_QUERY = "(min-width: 961px) and (min-height: 860px)";

export function prefersCalm() {
  return window.matchMedia("(prefers-reduced-motion: reduce)").matches;
}

function headerOffset() {
  const value = getComputedStyle(document.documentElement).getPropertyValue(
    "--header-offset"
  );
  return parseFloat(value) || 0;
}

// Live thread: posts are visible by default; only when motion is welcome do
// we hide them and let them arrive one by one as the card comes into view.
export const liveReveal = modifier((element) => {
  if (prefersCalm() || !("IntersectionObserver" in window)) {
    return;
  }

  element
    .querySelectorAll(".oaw-post-row")
    .forEach((row, i) => row.style.setProperty("--i", i));
  element.classList.add("is-armed");

  const observer = new IntersectionObserver(
    (entries) => {
      if (entries.some((entry) => entry.isIntersecting)) {
        element.classList.add("is-in");
        observer.disconnect();
      }
    },
    { threshold: 0.35 }
  );
  observer.observe(element);

  return () => observer.disconnect();
});

// Match poll: once the card is on screen, pick "Arsenal win", press Vote and
// reveal the real result from the derby thread. Runs once; with reduced
// motion the result simply fades in.
export const pollReveal = modifier((element) => {
  if (!("IntersectionObserver" in window)) {
    element.classList.add("is-voted");
    return;
  }

  const timers = [];
  const observer = new IntersectionObserver(
    (entries) => {
      if (!entries.some((entry) => entry.isIntersecting)) {
        return;
      }
      observer.disconnect();

      if (prefersCalm()) {
        element.classList.add("is-voted");
        return;
      }
      timers.push(setTimeout(() => element.classList.add("is-picked"), 500));
      timers.push(setTimeout(() => element.classList.add("is-pressed"), 950));
      timers.push(
        setTimeout(
          () => element.classList.replace("is-pressed", "is-voted"),
          1100
        )
      );
    },
    { threshold: 0.6 }
  );
  observer.observe(element);

  return () => {
    observer.disconnect();
    timers.forEach(clearTimeout);
  };
});

// Feature stack: while the next card slides up, the covered card recedes a
// touch and darkens. Scroll-linked, so the mapping is linear; skipped when
// motion is unwelcome (the cards still stack, they just don't recede).
export const stackRecede = modifier((element) => {
  if (prefersCalm()) {
    return;
  }

  const cards = [...element.querySelectorAll(".oaw-stack-card")];
  const stacking = window.matchMedia(STACKING_QUERY);
  let stickTops = [];
  let frame = null;

  const measure = () => {
    stickTops = cards.map(
      (card) => parseFloat(getComputedStyle(card).top) || 0
    );
  };

  const update = () => {
    frame = null;
    cards.forEach((card, i) => {
      const dim = card.querySelector(".oaw-stack-dim");
      const next = cards[i + 1];
      if (!next || !stacking.matches) {
        card.style.transform = "";
        dim.style.opacity = "";
        return;
      }
      const travel = window.innerHeight - stickTops[i + 1];
      const covered =
        (window.innerHeight - next.getBoundingClientRect().top) / travel;
      const p = Math.min(1, Math.max(0, covered));
      card.style.transform = `scale(${1 - 0.04 * p})`;
      dim.style.opacity = String(0.45 * p);
    });
  };

  const onScroll = () => {
    frame ??= requestAnimationFrame(update);
  };
  const onResize = () => {
    measure();
    update();
  };

  measure();
  update();
  window.addEventListener("scroll", onScroll, { passive: true });
  window.addEventListener("resize", onResize);

  return () => {
    window.removeEventListener("scroll", onScroll);
    window.removeEventListener("resize", onResize);
    if (frame) {
      cancelAnimationFrame(frame);
    }
  };
});

// Curtain reveal: on only when the closing band fits the screen below the
// forum header (else its title would stay hidden) and motion is welcome.
export const curtainFit = modifier((element) => {
  const closing = element.querySelector(".oaw-closing");

  const fit = () => {
    const room = window.innerHeight - headerOffset() - 24;
    const on = !prefersCalm() && !!closing && closing.offsetHeight <= room;
    element.classList.toggle("is-curtain", on);
  };

  fit();
  window.addEventListener("resize", fit);

  return () => window.removeEventListener("resize", fit);
});
