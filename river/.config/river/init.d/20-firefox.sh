# Detached videos are supposed to be floating and shown on all workspaces.
# Fullscreen videos also mean the system is not idling and should not go to
# sleep.
riverctl rule-add -app-id "firefox" -title "Picture-in-Picture" float

# The sharing indicator is quite annoying. :-/ If security is not a concern,
# the indicator can be completely disabled by setting the following options
# in 'about:config':
#
#   privacy.webrtc.hideGlobalIndicator → true
#   privacy.webrtc.legacyGlobalIndicator → false
#
# Otherwise, the following rules will make sure the indicator is shown on all
# workspaces and floating on top of the tiles.
riverctl rule-add -app-id "firefox" -title "Firefox — Sharing Indicator" float

# When Passkeys are used, Bitwarden pops up a window to select a passkey for
# the site. When not floating, the window is poorly rendered because it's
# designed to be a floating dialog.
riverctl rule-add -app-id "firefox" -title "Bitwarden" float
