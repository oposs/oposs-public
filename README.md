---
title: Oetiker+Partner Open Source Guix package channel
---

# Installation
This channel can be installed as a
[[https://www.gnu.org/software/guix/manual/en/html_node/Channels.html][Guix
channel]].  To do so, add it to `~/.config/guix/channels.scm`:

    (cons* (channel
            (name 'oposs)
            (url "https://github.com/oposs/oposs-public"))
           %default-channels)
Then run `guix pull`.
