import Component from "@glimmer/component";
import { on } from "@ember/modifier";
import { service } from "@ember/service";
import bodyClass from "discourse/helpers/body-class";
import hideApplicationHeaderButtons from "discourse/helpers/hide-application-header-buttons";
import hideApplicationSidebar from "discourse/helpers/hide-application-sidebar";
import routeAction from "discourse/helpers/route-action";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { settings } from "virtual:theme";
import {
  curtainFit,
  liveReveal,
  pollReveal,
  splitFlap,
  stackRecede,
} from "../lib/oa-welcome-motion";
import OaWelcomePlayers from "./oa-welcome-players";

const UNSPLASH = "?utm_source=online_arsenal&utm_medium=referral";

// Kick-off of the 23 Nov 2025 derby (16:30 GMT) on the clocks where members
// watch from. Each character becomes its own split-flap tile.
const CLOCKS = [
  ["New York", "11:30", "2025-11-23T11:30-05:00", "Sun"],
  ["London", "16:30", "2025-11-23T16:30+00:00", "Sun"],
  ["Amsterdam, Berlin, Stockholm", "17:30", "2025-11-23T17:30+01:00", "Sun"],
  ["Mumbai", "22:00", "2025-11-23T22:00+05:30", "Sun"],
  ["Sydney", "03:30", "2025-11-24T03:30+11:00", "Mon"],
].map(([city, time, datetime, day]) => ({
  city,
  time,
  datetime,
  day,
  nextDay: day !== "Sun",
  chars: [...time].map((char) => ({ char, digit: char !== ":" })),
}));

// Replaces the stock login-required page for logged-out visitors. The forum
// header stays, with its Sign Up and Log In buttons, as the always-there way
// in; search and the menu are hidden because they lead nowhere while the
// forum is closed.
export default class OaWelcome extends Component {
  @service site;
  @service siteSettings;

  uploads = settings.theme_uploads ?? {};
  clocks = CLOCKS;
  unsplash = UNSPLASH;

  // Same rule as the application controller's canSignUp, which the stock
  // page uses to decide whether to offer Sign Up at all.
  get canSignUp() {
    return (
      !this.site.isReadOnly &&
      !this.siteSettings.invite_only &&
      this.siteSettings.allow_new_registrations &&
      !this.siteSettings.enable_discourse_connect
    );
  }

  <template>
    {{hideApplicationHeaderButtons "search" "menu"}}
    {{hideApplicationSidebar}}
    {{bodyClass "oa-welcome-page"}}

    <div class="oa-welcome" {{curtainFit}}>
      <div class="oaw-wrap">
        <div class="oaw-curtain">

          <section class="oaw-hero">
            <div class="oaw-hero-photo" aria-hidden="true"></div>
            <div class="oaw-hero-text">
              <h1 class="oaw-h1">We've been talking Arsenal since&nbsp;2003.</h1>
              <p class="oaw-lead">A supporters' forum with a thread for every
                match, every player and every transfer rumour, and fans from
                all over ready to tell you you're&nbsp;wrong.</p>
              <div class="oaw-actions">
                {{#if this.canSignUp}}
                  <button
                    type="button"
                    class="oaw-btn oaw-btn-join"
                    {{on "click" (routeAction "showCreateAccount")}}
                  >Join the forum</button>
                {{/if}}
                <button
                  type="button"
                  class="oaw-btn oaw-btn-login"
                  {{on "click" (routeAction "showLogin")}}
                >Log in</button>
              </div>
              <p class="oaw-fine">Free to join. No ads, ever.</p>
            </div>
            <div class="oaw-hero-visual" aria-hidden="true">
              <img
                class="oaw-hero-mockup"
                src={{this.uploads.hero_mockup}}
                alt=""
                width="988"
                height="2000"
              />
            </div>
          </section>

          <section class="oaw-stack" {{stackRecede}}>

            <article class="oaw-stack-card" style="--i: 0">
              <div class="oaw-stack-dim" aria-hidden="true"></div>
              <div class="oaw-stack-text">
                <p class="oaw-note">Matchday threads</p>
                <h2 class="oaw-h2">Talk every match through, from team news to
                  full&nbsp;time.</h2>
                <p class="oaw-lead">Each game gets its own matchday thread. Call
                  the result before kick-off, suffer through the ninety
                  together, then do the post-mortem.</p>
              </div>
              <div class="oaw-card" aria-hidden="true">
                <div class="oaw-badges">
                  <span class="oaw-badge oaw-badge--accent">Premier League</span>
                  <span class="oaw-badge">North London derby</span>
                </div>
                <h3>Arsenal vs Tottenham</h3>
                <p class="oaw-sub">Emirates Stadium</p>
                <img
                  class="oaw-photo"
                  src={{this.uploads.photo_emirates}}
                  alt=""
                  loading="lazy"
                  width="1200"
                  height="800"
                />
                <div class="oaw-poll" {{pollReveal}}>
                  <div class="oaw-option" style="--p: 0.88; --n: 0"><i></i>Arsenal
                    win<b>88%</b><s></s></div>
                  <div class="oaw-option" style="--p: 0.08; --n: 1"><i
                    ></i>Draw<b>8%</b><s></s></div>
                  <div class="oaw-option" style="--p: 0.04; --n: 2"><i></i>Spurs
                    win<b>4%</b><s></s></div>
                  <div class="oaw-poll-foot">
                    <span class="oaw-vote-btn">Vote</span>
                    <span class="oaw-poll-total">{{dIcon "lock"}}26 voters ·
                      Closed 23 Nov</span>
                  </div>
                </div>
              </div>
            </article>

            <article class="oaw-stack-card" style="--i: 1">
              <div class="oaw-stack-dim" aria-hidden="true"></div>
              <div class="oaw-stack-text">
                <p class="oaw-note">As it happens</p>
                <h2 class="oaw-h2">Celebrate every goal in capital&nbsp;letters.</h2>
                <p class="oaw-lead">Seconds after it hits the net, the whole
                  thread loses its mind. Scenes.</p>
              </div>
              <figure
                class="oaw-live"
                aria-label="Reactions from the match thread"
                {{liveReveal}}
              >
                <div class="oaw-thread">
                  <div class="oaw-thread-head">
                    <span class="oaw-thread-score">Arsenal 4–1 Tottenham</span>
                    <span class="oaw-thread-scorers">Trossard 36′ · Eze 41′ 46′
                      76′</span>
                  </div>
                  <ol class="oaw-posts">
                    <li class="oaw-post-row"><span
                        class="oaw-letter"
                        style="background:#8a6a3c"
                      >E</span><p>EZEEEEEEEEEE</p></li>
                    <li class="oaw-post-row"><span
                        class="oaw-letter"
                        style="background:#5b7fa6"
                      >S</span><p>That run from Tross and the pass from Merino.
                        Just class.</p></li>
                    <li class="oaw-post-row"><span
                        class="oaw-letter"
                        style="background:#9a5a7f"
                      >A</span><p>EZEDINHOOOOO</p></li>
                    <li class="oaw-post-row"><span
                        class="oaw-letter"
                        style="background:#8a6a3c"
                      >E</span><p>SBDHSJKSUFHDJSKSISHSHSH</p></li>
                    <li class="oaw-post-row"><span
                        class="oaw-letter"
                        style="background:#6f8a4f"
                      >S</span><p>EZECHUKWU!!! What a goal!!</p></li>
                  </ol>
                </div>
                <figcaption>From the match thread, North London derby, 23
                  November 2025.</figcaption>
              </figure>
            </article>

            <OaWelcomePlayers />

          </section>

          <section class="oaw-extras">
            <p class="oaw-note">Extras</p>
            <h2 class="oaw-h2">Something to get you through the international&nbsp;break.</h2>
            <div class="oaw-extras-grid">
              <article class="oaw-extra">
                <div class="oaw-extra-visual oaw-pitch-view" aria-hidden="true">
                  <div class="oaw-pitch">
                    <span class="oaw-ln oaw-ln-half"></span>
                    <span class="oaw-ln oaw-ln-circle"></span>
                    <span class="oaw-ln oaw-ln-box oaw-ln-top"></span>
                    <span class="oaw-ln oaw-ln-box oaw-ln-bottom"></span>
                    <span class="oaw-dot" style="--x:50%; --y:12%"></span>
                    <span class="oaw-dot" style="--x:17%; --y:36%"></span>
                    <span class="oaw-dot" style="--x:50%; --y:36%"></span>
                    <span class="oaw-dot" style="--x:83%; --y:36%"></span>
                    <span class="oaw-dot" style="--x:34%; --y:56%"></span>
                    <span class="oaw-dot" style="--x:66%; --y:56%"></span>
                    <span class="oaw-dot" style="--x:12%; --y:72%"></span>
                    <span class="oaw-dot" style="--x:37%; --y:72%"></span>
                    <span class="oaw-dot" style="--x:63%; --y:72%"></span>
                    <span class="oaw-dot" style="--x:88%; --y:72%"></span>
                    <span class="oaw-dot" style="--x:50%; --y:88%"></span>
                  </div>
                </div>
                <h3>Be the gaffer: pick the XI you'd send&nbsp;out.</h3>
                <p>Type eleven names and your post turns into a pitch, in the
                  formation of your choice.</p>
              </article>
              <article class="oaw-extra">
                <div class="oaw-extra-visual" aria-hidden="true">
                  <div class="oaw-bet">
                    <div class="oaw-bet-head">
                      <small>Premier League</small>
                      <strong>Arsenal vs Tottenham</strong>
                    </div>
                    <div class="oaw-picks">
                      <span class="is-picked">Arsenal</span>
                      <span>Draw</span>
                      <span>Tottenham</span>
                    </div>
                    <div class="oaw-stake">
                      <span>Amount (min 10)</span>
                      <b>Place bet</b>
                    </div>
                  </div>
                </div>
                <h3>Fancy yourself as the forum's best&nbsp;tipster?</h3>
                <p>Prove it in Bookie: back your calls with virtual coins and
                  climb the league table. No real money involved.</p>
              </article>
              <article class="oaw-extra">
                <div class="oaw-extra-visual" aria-hidden="true">
                  <div class="oaw-games">
                    <span><img
                        src={{this.uploads.arcade_penalty}}
                        alt=""
                        width="320"
                        height="180"
                      />Penalty</span>
                    <span><img
                        src={{this.uploads.arcade_keepie}}
                        alt=""
                        width="320"
                        height="180"
                      />Keepie Uppie</span>
                    <span><img
                        src={{this.uploads.arcade_dribble}}
                        alt=""
                        width="320"
                        height="180"
                      />Dribble</span>
                    <span><img
                        src={{this.uploads.arcade_2048}}
                        alt=""
                        width="320"
                        height="180"
                      />2048</span>
                    <span><img
                        src={{this.uploads.arcade_snake}}
                        alt=""
                        width="320"
                        height="180"
                      />Snake</span>
                    <span><img
                        src={{this.uploads.arcade_breakout}}
                        alt=""
                        width="320"
                        height="180"
                      />Breakout</span>
                  </div>
                </div>
                <h3>Bragging rights, settled every month in the&nbsp;Arcade.</h3>
                <p>A dozen games, from Penalty to 2048, each with its own
                  leaderboard.</p>
              </article>
            </div>
          </section>

          <section class="oaw-everywhere">
            <div>
              <p class="oaw-note">Who's on here</p>
              <h2 class="oaw-h2">Most of us have never met. All of us lost sleep
                over the same&nbsp;game.</h2>
              <p class="oaw-lead">Mostly UK, with the rest spread from
                New&nbsp;York to Sydney. Some of us make it to the ground,
                plenty are the only Arsenal fan in the room. On here, the room
                is&nbsp;full.</p>
            </div>
            <figure
              class="oaw-kickoff oaw-card"
              aria-label="Kick-off of Arsenal vs Tottenham in local time"
            >
              <div class="oaw-badges">
                <span class="oaw-badge oaw-badge--accent">Premier League</span>
                <span class="oaw-badge">North London derby</span>
              </div>
              <h3>Arsenal vs Tottenham</h3>
              <p class="oaw-sub">Kick-off, 23 November 2025</p>
              <ol class="oaw-clocks" {{splitFlap}}>
                {{#each this.clocks as |clock|}}
                  <li><span>{{clock.city}}</span><time
                      datetime={{clock.datetime}}
                      aria-label={{clock.time}}
                    >{{#each clock.chars as |c|}}{{#if c.digit}}<span
                            class="oaw-flap"
                            data-d={{c.char}}
                            aria-hidden="true"
                          ></span>{{else}}<span
                            class="oaw-flap-colon"
                            aria-hidden="true"
                          >:</span>{{/if}}{{/each}}</time><span
                      class="oaw-day {{if clock.nextDay 'oaw-next-day'}}"
                    >{{clock.day}}</span></li>
                {{/each}}
              </ol>
            </figure>
          </section>

        </div>

        <section class="oaw-closing">
          <div class="oaw-closing-photo" aria-hidden="true"></div>
          <div class="oaw-closing-inner">
            <div>
              <h2 class="oaw-h2">Pull up a seat.</h2>
              <p class="oaw-lead">No waiting list, unlike the Emirates. No ads,
                ever. Join for free, or log in to pick up where you left&nbsp;off.</p>
            </div>
            <div class="oaw-actions">
              {{#if this.canSignUp}}
                <button
                  type="button"
                  class="oaw-btn oaw-btn-join"
                  {{on "click" (routeAction "showCreateAccount")}}
                >Join the forum</button>
              {{/if}}
              <button
                type="button"
                class="oaw-btn oaw-btn-login"
                {{on "click" (routeAction "showLogin")}}
              >Log in</button>
            </div>
          </div>
          <footer class="oaw-footer">
            <div class="oaw-footer-brand">
              <img
                class="oaw-footer-logo"
                src={{this.uploads.logo_small}}
                alt=""
                width="125"
                height="64"
              />
              <p>Online Arsenal, est. 2003. Not affiliated with Arsenal&nbsp;FC.</p>
            </div>
            <p>Photos by
              <a
                href="https://unsplash.com/@james_open{{this.unsplash}}"
              >James Kirkup</a>,
              <a
                href="https://unsplash.com/@huyphan2602{{this.unsplash}}"
              >Huy Phan</a>
              and
              <a
                href="https://unsplash.com/@whodunelson{{this.unsplash}}"
              >Nelson Ndongala</a>
              on
              <a href="https://unsplash.com/{{this.unsplash}}">Unsplash</a></p>
          </footer>
        </section>
      </div>
    </div>
  </template>
}
