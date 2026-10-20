import { apiInitializer } from "discourse/lib/api";
import OaWelcome from "../components/oa-welcome";

// login-required is a wrapper outlet around the whole stock page, so this
// connector replaces it entirely for logged-out visitors.
export default apiInitializer((api) => {
  api.renderInOutlet("login-required", OaWelcome);
});
