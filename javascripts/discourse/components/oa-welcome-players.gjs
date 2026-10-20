import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { modifier } from "ember-modifier";
import { eq } from "discourse/truth-helpers";
import { prefersCalm } from "../lib/oa-welcome-motion";

const PLAYERS = [
  {
    tab: "Saka",
    title: "Starboy in the form of his life? Talk about it in his thread.",
    shirt: "SAKA",
    number: "7",
    role: "Winger",
    nation: "England",
    name: "Bukayo Saka",
    sub: "Bukayo Ayoyinka Temidayo Saka · 5 September 2001, Ealing",
    bio: "Hale End's finest. Cuts in on his left, terrorises full-backs and has carried the right wing for years.",
    position: "RW",
    contract: "June 2030",
  },
  {
    tab: "Ødegaard",
    title: "Ode pulling the strings again? Talk about it in his thread.",
    shirt: "ØDEGAARD",
    number: "8",
    role: "Midfielder",
    nation: "Norway",
    name: "Martin Ødegaard",
    sub: "Martin Ødegaard · 17 December 1998, Drammen",
    bio: "Came on loan from Real Madrid in 2021 and signed for good that summer. Captain since 2022, and still sees passes nobody else does.",
    position: "AM, CM",
    contract: "June 2028",
  },
  {
    tab: "Timber",
    title:
      "Timber the best right-back in the league? Talk about it in his thread.",
    shirt: "TIMBER",
    number: "12",
    role: "Defender",
    nation: "Netherlands",
    name: "Jurriën Timber",
    sub: "Jurriën David Norman Timber · 17 June 2001, Utrecht",
    bio: "Signed from Ajax in 2023 and lost nearly all of his first season to an ACL. Since then, a right-back who drifts inside like a sixth midfielder.",
    position: "RB, CB",
    contract: "June 2028",
  },
];

// Player threads: Saka, Ødegaard and Timber take turns. The line under the
// active name sets the pace: when it has filled, the next player comes in.
// It holds on hover, on focus and off screen; picking a name ends the turns,
// and with reduced motion they never start.
export default class OaWelcomePlayers extends Component {
  @tracked current = 0;
  @tracked autoplay = !prefersCalm();
  @tracked offscreen = true;
  @tracked hovered = false;
  @tracked focused = false;

  players = PLAYERS;

  watchOffscreen = modifier((element) => {
    if (!("IntersectionObserver" in window)) {
      this.offscreen = false;
      return;
    }
    const observer = new IntersectionObserver(
      ([entry]) => (this.offscreen = !entry.isIntersecting),
      { threshold: 0.5 }
    );
    observer.observe(element);
    return () => observer.disconnect();
  });

  get paused() {
    return this.offscreen || this.hovered || this.focused;
  }

  @action
  pick(index) {
    this.autoplay = false;
    this.current = index;
  }

  @action
  advance(event) {
    if (event.animationName === "oaw-tab-fill" && this.autoplay) {
      this.current = (this.current + 1) % this.players.length;
    }
  }

  @action
  pointerEnter(event) {
    if (event.pointerType === "mouse") {
      this.hovered = true;
    }
  }

  @action
  pointerLeave() {
    this.hovered = false;
  }

  @action
  focusIn() {
    this.focused = true;
  }

  @action
  focusOut() {
    this.focused = false;
  }

  <template>
    <article
      class="oaw-stack-card oaw-players
        {{if this.autoplay 'is-autoplay'}}
        {{if this.paused 'is-paused'}}"
      style="--i: 2"
      {{on "animationend" this.advance}}
      {{on "pointerenter" this.pointerEnter}}
      {{on "pointerleave" this.pointerLeave}}
      {{on "focusin" this.focusIn}}
      {{on "focusout" this.focusOut}}
    >
      <div class="oaw-stack-dim" aria-hidden="true"></div>
      <div class="oaw-stack-text">
        <p class="oaw-note">Player threads</p>
        <div class="oaw-rotate">
          {{#each this.players as |player index|}}
            <h2
              class="oaw-h2 oaw-slide
                {{if (eq index this.current) 'is-active'}}"
            >{{player.title}}</h2>
          {{/each}}
        </div>
        <p class="oaw-lead">Every first-team player has his own thread: the
          essentials pinned up top, every worldie and every wobble
          underneath.</p>
        <div class="oaw-player-tabs">
          {{#each this.players as |player index|}}
            <button
              type="button"
              class={{if (eq index this.current) "is-active"}}
              aria-current={{if (eq index this.current) "true"}}
              {{on "click" (fn this.pick index)}}
            >{{player.tab}}<i></i></button>
          {{/each}}
        </div>
      </div>
      <div class="oaw-rotate" aria-hidden="true" {{this.watchOffscreen}}>
        {{#each this.players as |player index|}}
          <div
            class="oaw-card oaw-player oaw-slide
              {{if (eq index this.current) 'is-active'}}"
          >
            <div class="oaw-shirt"><small>{{player.shirt}}</small><strong
              >{{player.number}}</strong></div>
            <div>
              <div class="oaw-badges">
                <span class="oaw-badge oaw-badge--accent">{{player.role}}</span>
                <span class="oaw-badge">{{player.nation}}</span>
              </div>
              <h3>{{player.name}}</h3>
              <p class="oaw-sub">{{player.sub}}</p>
            </div>
            <p class="oaw-bio">{{player.bio}}</p>
            <div class="oaw-facts">
              <div data-label="Position">{{player.position}}</div>
              <div data-label="Contract">{{player.contract}}</div>
              <div data-label="Squad number">{{player.number}}</div>
            </div>
          </div>
        {{/each}}
      </div>
    </article>
  </template>
}
