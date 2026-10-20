import { apiInitializer } from "discourse/lib/api";
import OaAuthCredit from "../components/oa-auth-credit";
import OaWelcome from "../components/oa-welcome";

// login-required is a wrapper outlet around the whole stock page, so this
// connector replaces it entirely for logged-out visitors. The credit shows
// only on the login and sign-up pages, under their photo background.
export default apiInitializer((api) => {
  api.renderInOutlet("login-required", OaWelcome);
  api.renderInOutlet("after-main-outlet", OaAuthCredit);
});
