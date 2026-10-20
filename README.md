# OA Welcome

Custom welcome page for logged-out visitors of the Online Arsenal forum, shown
when the forum is closed (`login_required`). A Discourse theme component that
replaces the stock page through the `login-required` wrapper outlet.

## Layout

- `javascripts/discourse/api-initializers/oa-welcome.gjs`: hooks the page
  into the `login-required` outlet.
- `javascripts/discourse/components/oa-welcome.gjs`: the page.
- `javascripts/discourse/components/oa-welcome-players.gjs`: the rotating
  player card (Saka, Ødegaard, Timber).
- `javascripts/discourse/lib/oa-welcome-motion.js`: scroll and reveal
  behaviour (live thread, poll, sticky stack, curtain reveal).
- `common/common.scss`: all styles. Every class carries the `oaw-` prefix.
- `assets/`: self-hosted fonts and images (see below).
- `design/`: the static design preview the component was ported from.

The forum header keeps its Sign Up and Log In buttons; the page hides only
search and the menu. Content lives in the code, with no admin settings.

## Installing

Admin → Customize → Themes → Install → from a git repository, then add the
component to the active theme(s). Updates: push, then "Check for updates".

## Credits and licences

- Photos from Unsplash (Unsplash License): crowd by
  [James Kirkup](https://unsplash.com/@james_open), empty seats by
  [Huy Phan](https://unsplash.com/@huyphan2602), Emirates Stadium by
  [Nelson Ndongala](https://unsplash.com/@whodunelson).
- Fonts: Outfit and Caveat Brush, SIL Open Font License 1.1 (see
  `assets/fonts/OFL-*.txt`).
- Arcade thumbnails come from the discourse-arcade plugin.
