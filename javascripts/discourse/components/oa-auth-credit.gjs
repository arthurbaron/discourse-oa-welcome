import Component from "@glimmer/component";
import { service } from "@ember/service";

const AUTH_ROUTES = ["login", "signup"];

// Credit for the crowd photo behind the login and sign-up card, centred at
// the bottom of those two pages only.
export default class OaAuthCredit extends Component {
  @service router;

  get show() {
    return AUTH_ROUTES.includes(this.router.currentRouteName);
  }

  <template>
    {{#if this.show}}
      <p class="oaw-auth-credit">Photo by
        <a
          href="https://unsplash.com/@james_open?utm_source=online_arsenal&utm_medium=referral"
        >James Kirkup</a>
        on
        <a
          href="https://unsplash.com/?utm_source=online_arsenal&utm_medium=referral"
        >Unsplash</a></p>
    {{/if}}
  </template>
}
