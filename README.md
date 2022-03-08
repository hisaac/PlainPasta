<p align="center">
	<img src="./Assets/app-icon-512@2x.png" width="256px" alt="Plain Pasta's app icon" />
</p>

# Plain Pasta

Plain Pasta was a tiny Mac app that makes "Paste and Match Style" the default copy/paste behavior.

## ⚠️ Plain Pasta is no longer under active development ⚠️

This was a really fun project to work on, but I will no longer be actively developing on the project. I'm leaving it here in case there is any code that could still be useful to others.

If you're looking for something like Plain Pasta that _is_ still being developed, I'll direct you to the excellent [Pure Paste](https://sindresorhus.com/pure-paste) by [@sindresorhus](https://github.com/sindresorhus). It does everything I had hoped for Plain Pasta to do someday, and then some.

👋

## Demonstration

Plain Pasta sits in your menu bar, and watches your clipboard for text, removes any styling from the text, and puts plaintext back on your clipboard.

I made this app because I rarely want styling to be copied to my clipboard. When I copy text, all I want is the text.

Download the most recent version of Plain Pasta from the [Mac App Store](https://apps.apple.com/us/app/plain-pasta/id1467796430).

### Without Plain Pasta

<figure>
	<a href="./docs/without-plain-pasta.gif">
		<img src="./docs/without-plain-pasta.gif" alt="A screen recording of text and style being copy/pasted" />
	</a>
	<figcaption><p align="center">Copy/Pasting styled text takes both the text <em>and</em> the styling with it</p></figcaption>
</figure>

### With Plain Pasta

<figure>
	<a href="./docs/with-plain-pasta.gif">
		<img src="./docs/with-plain-pasta.gif" width="100%" alt="A screen recording of text being copy/pasted without its styling" />
	</a>
	<figcaption><p align="center">Copy/Pasting styled text <em>with</em> Plain Pasta enabled only pastes the text itself, no styling</p></figcaption>
</figure>

## Contributing

PRs are more than welcome!

To get up and running, you'll need to clone this repo, and then initialize the [`VerifyNoBS`](https://github.com/olofhellman/VerifyNoBS) submodule using:

```
git submodule update --init
```

## Attribution

Plain Pasta was inspired by another app called [FormatMatch](https://itunes.apple.com/us/app/formatmatch/id445211988?mt=12) by [Robert Wessels](http://www.robertwessels.com).

I've used FormatMatch for many years. I would've happily used it for many more years to come, but the app hasn't been updated for over 6 years, and Robert Wessel's website is no longer live. I've been concerned for the continued life of the app, so I finally decided to take the time to write a new version using modern technologies.

- Icon image is [Noodles by Paolo Valzania from the Noun Project](https://thenounproject.com/search/?q=noodle&i=1681744)
- Clipboard monitoring code based on [klipsustreamer](https://github.com/lahdekorpi/klipsustreamer) by [Toni Lähdekorpi](https://github.com/lahdekorpi)
