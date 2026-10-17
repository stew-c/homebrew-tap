# stew-c/tap

Homebrew formulae that aren't in homebrew-core.

| Formula | Description |
| ------- | ----------- |
| `drawterm` | Connect to Plan 9 and 9front CPU servers from macOS (9front's drawterm) |

## How do I install these formulae?

`brew install stew-c/tap/<formula>`

Or `brew tap stew-c/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "stew-c/tap"
brew "<formula>"
```

No bottles are published, so formulae build from source on install.

## Updates

Formulae with upstream releases are bumped by `autobump.yml`.

Formulae for projects with no releases, such as `drawterm`, are pinned to a
commit and versioned by its date (`YYYY.MM.DD`). `bump-pinned.yml` runs daily:
when `livecheck` finds a newer commit, it repins the formula, builds and tests
it on macOS, and commits the result, so `brew update` then shows it as outdated.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
