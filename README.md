# Dotfiles

My configuration for primarily MacOS machines. Working on getting this setup with nix (using nix-darwin). Will contain as much of my productivity tooling as possible including but not limited to:

- Developer apps (terminal emulator, docker, etc)
- quality of life apps (tiling window manager, etc)
- macOS native configuration (typing speed, dock config, ...)
- packages

and more. Maybe in the future will also include home-manager although I hear it's a pain in the ass.

The eventual goal is to easily manage my system configuration across a personal
macbook pro as well as a homelab mac studio running AI inference.

## Homelab Architecture Ideas

- Runtime options: `llama.cpp`, `MLX`, `mlx-lm`, `vmlx-swift-lm`, antirez's `ds4`
- Server: `ollama serve`, `llama-server`, `mlx_lm.server`, `Osaurus`,
`vllm-mlx`, `Rapid-MLX`, `oMLX`, `ds4-server`
- Harness: `pi`, `hermes`
- Frontend: Osaurus chat, `Jan`, `LM Studio`, `MLX Studio`, `Open WebUI`

### Runtimes on Apple Silicon

The *compute backend* is the runtime which runs matmuls (i.e where on the chip
the work actually happens). The following three options cover local **text**
inference on M-series chips. Picking a runtime trades off inference speed as
well as how fast new model architectures are supported.

- PyTorch + MPS (Metal Performance Shaders) is the baseline. ML code reaches
apple silicon through PyTorch, so new architectures will be supported first like
this. The speed is okay.
- llama.cpp has hand-written Metal kerners instead of going through MPS. It is
the engine used to power Ollama and llama-server. Pretty fast, wide coverage,
consumes GGUF.
- MLX is Apple's own array framework. Faster on supported models, less
mainstream, and sometimes lagging by months on new architectures. Osaurus,
mlx-lm, and JANG stack all use it.

For image models - CoreML on the Neural Engine has the lowest resource
footprint.

### Weight formats and quantization

Model weights ship in various storage formats subject to optional quantization.
The bottleneck on consumer hardware is usually RAM. For example, a 70b param
model at fp16 full precision is ~140gb and will not fit on a 128 GB mac. There
are several popular formats:

- `safetensors` - Hugging Face baseline. Full precision. This is what PyTorch +
MPS loads when the model fits without help
- GGUF - `llama.cpp` format. Not Apple-specific since it also runs on CUDA and
CPU. Widest model coverage and finest quants down to even IQ2 / IQ3 `imatrix` quants.
- `MLX` (mlx-community) - native MLX format, Apple-only. Quantized to fit but
has added speed on M-series. Coverage will lag.
- JANG - mixed-precision extension to MLX. Each tensor will have its own
bit-widths instead of one fixed width for the whole format.

As a rule of thumb I will prefer MLX builds for speed when one is published. If
not, then GGUF. Worst case is safetensors.

### Mixed-precision MLX

Topic to research for later

### Weights repositories

Nearly everything gets weights from Hugging Face. However, different opensource
toolchains locally store these weights in different locations so it is easy to
end up with copies of large blobs. So, I need to sort out configuration ahead of
time to prevent having to do crazy disk auditing later.

`transformers` and `mlx-lm` share one cache `~/.cache/huggingface/hub`. We can
name a repo and the weights will land there on first download, with every
subsequent request being served from the cache.

Other ones are "directory-scanning servers". `Osaurus`, `oMLX`, `LM Studio`,
`MLX Studio`. Each of these wants to see a folder of model subdirectories. Each
of these has its own default location. `~/MLXModels`, oMLX's `--model-dir`,
`~/.lmstudio`, `~/.mlxstudio/models`.

Pick one folder and point each server at it. In the folder, mirrow each model's
`org/repo` path. Then even for manual downloads we can do

```bash
hf download $repo --local-dir ~/MLXModels/$repo
```

for example.

`ollama` is a whole different beast with a bunch of duplication. I will probably
avoid it.

### Memory management

This part is pretty technical.

First of all, it seems that macOS's "Memory Used" indicator does not measure how
much RAM is committed to a process in the way I thought before. I'll get into
the details later, but for now:

- use `mactop` as a lightweight resource monitor
- MacOS by default sets a limit of 75% of RAM allocation for metal on macs
larger than 36gb ram. At runtime we can use `sudo sysctl` to increase the
available allocation
- This might be manageable through nix darwin sine this configuration doesn't
persists across sessions

### Serving a model headless

I skipped a section about full-stack desktop apps which essentially bundle all
of the layers. Instead I would like to serve a model as a *daemon* - a
long-lived process with an OpenAI-compatible API.

Some of the considerations here involve model lifecycle:

- How many models stay resident at once
- Who decides which
- What a switch costs against the established memory ceiling

There are two ways to think abou this:

1. a server holds many models and rations them internally - `vllm-mlx` and `oMLX`
2. server holds exactly one model, and a router in front starts and stops them -
   something like `llama-swap`

### Takeaways thus far

Let's start by picking one model - qwen 3.8 27b. Serve with vllm-mlx. . We'll
setup ~/MLXModels with mlx-community/Qwen3.8-27B-bf16. There is some
configuration here with `--models-config models.yaml`

vllm-mlx provides:

- [Continuous Batching](https://huggingface.co/blog/continuous_batching) - processing multiple conversations in parallel and swapping them out when they are down. This is its own topic and will need to be studied. Useful for enabling high-load serving.
- Paged KV cache
- Prefix Caching
- SSD-tiered cache
- Exposes both OpenAI and Anthropic compatible APIs
- Multimodal support
- Prometheus metrics
- Built-in benchmarking

Recommended installation is using `uv` with `uv tool install vllm-mlx`

## TODO List (migrating over from an Apple Note

- [x] Install Homebrew via `brew.sh`
- [x] Install GitHub CLI since password-based authentication is deprecated in git. Install with brew
- [x] Purchase and install TabTap (<https://tabtabapp.net>) for convenient tab and window switching.
- [x] Install Homerow (<https://www.homerow.app>) for keyboard-based UI navigation
- [x] Install Nix onto my main Macbook Pro
- [x] Setup nix-darwin as a flake, checked into github
- [ ] Install neovim eventually as well as my developer dependencies
  - [x] fzf
  - [x] zoxide
  - [x] lazygit
- [x] Remap caps lock to control somehow (ideally using nix-darwin config) for better productivity in the terminal
- [x] Properly configure clipboard for yank in vim and neovim
- [x] Decrease the latency between keystrokes as much as possible using nix-darwin
- [x] Experiment with GNU stow for managing my config
- [ ] Figure out how to make darwin-rebuild only keep the declared configuration every time (fresh slate)
- [ ] Build zshell config or prevent the dialogue every time when I open a terminal
- [ ] use `nixfmt` as the linter for my nix flakes. Actually seems to be an issue here with precommit and this particular hook, so will try something else.
- [x] Installed and configured aerospace (tiling window manager based on i3).
Much nicer to use than yabai. Faster and more responsive as well.

## Objectives for an AI workstation

## Why Use Nix on a Mac?

- [Nixpkgs](https://search.nixos.org/packages) is allegedly the "biggest and freshest open-source package repository in the world". According to automated analysis by [Repology](https://repology.org/repositories/graphs)
- Better than homebrew (pseudo-native Mac package manager) by a longshot
- *Same packages cross platform*. A nix package on macos will be the same as debian, fedora, etc, at the very least in terms of versions.
- "per project toolchain management". Apparently `nix develop` allows develops and administrators to easily manage toolchains and potentially avoid docker if they really wanted to.
- `nix-darwin`. A nix module that allows declarative config of nearly all macOS system settings. As well as packages/apps, and some of their configuration. Integration with `launchd` (not sure the implications there).

## Nix Installation

While the simplest way to install nix, say, on a random linux machine is to use another package manager to install it using another package manager, that is not recommended at all.

Note that one primary resource I'm using here is [Setting up Nix on macOS](https://nixcademy.com/posts/nix-on-macos/) from Nixcademy.

There are 3 ways to install nix on macOS which are known to work pretty well.

1. Official Nix installer from `nixos.org`
2. New yet-unofficial Nix Installer from `nixos.org` (stable, and seems to be preferred. also allows for Nix Flakes to be enabled which I will get to later).
3. Determinate System's Nix Installer. Determinate Nix is a downstream distribution of nix with other features. Deviates from vanilla - we will probably stick with vanilla nix for now.

We're going to use the new-but-stable unofficial installer. Snippet here:

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

We are going to choose the multi-user installation option rather than single-user.

- Note after the fact, that I do not recall seeing an option / user input confirming multi vs single user installation. I have to verify that multi-user was installed.

After some basic installation ack's as well as a shell restart, we can use `nix run` to ephemerally test whether the installation can run the GNU Hello package from Nixpgs.

```bash
nix run nixpkgs#hello
```

Note that there is a Nix (and NixOS) [cheatsheet](https://nixcademy.com/cheatsheet/) which can be used as a reference for common commands.

### Nix Darwin

Now with Nix installed, we have all of the nix shell commands (`nix develop` and `nix shell`) and can now build and run (`nix build` and `nix run`) projects.

However, we don't want to run `nix profile install ...` on every mac host - this would not be better than classical papackage management solutions. Also we won't be able to manage configurations and services on macOS using `nix profile install`.

Instead we want one big configuration file(s) which we can deploy with one single command. `nix-darwin` brings us a declaritive system approach to macOS.

In order to bootstrap, we can initialize a new `nix-darwin` configuration file.

```bash
mkdir nix-darwin-config
cd nix-darwin-config
nix flake init -t nix-darwin
```

Note: the `-t` flag means a template.

This will simply create a `flake.nix` file as so:

```nix
{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  }; 
}
```

There are a lot of sections here, but don't be overwhelmed. I'm going to change 2 things:

1. `nixpgs.hostPlatform` will be `aarch64-darwin` since I'm running Apple Silicon.
2. `simple` in the bottom of the file under `darwinConfigurations."simple"` will be renamed to my host machine (tbd). This allows us to not have to provide the host name explicitly every time we build or rebuild the system configuration.

Now we can boostrap as follows:
`nix run nix-darwin -- switch --flake .` from the directory of the flake.

Note that if we didn't rename the host name attribute, the last parameter needs to be `--flake .#simple`

The installation process will warn of files which could be destructively overwritten. If necessary you can back them up or just delete them yourself. Once you're ready you can run the script again.

Now we should have `nix-darwin` on our system which provides a `darwin-rebuild` command allowing us to run `darwin-rebuild switch --flake .` anytime.

Note: For some reason, I had to run the bootstrap command using sudo.

Note that this is similar to `nixos-rebuild` command in NixOS.

## nix-darwin Configuration Goodies

Now, we can explore the treasures of the [nix-darwin configuration options documentation](https://nix-darwin.github.io/nix-darwin/manual/index.html). here are some examples. I won't add the code snippets here, they are largely in the article I linked above as well as can be referenced in the configuration docs.

- Unlock `sudo` with Touch ID
- Setting System Defaults
  - pretty much anything that you can configure using the macOS UI or the `defaults` command in the terminal can be managed by nix-darwin
- Optionally can enable support for Intel binaries in Apple Silicon Macs via configuring Rosetta as well as changing `nix.extraOptions`. Now you can build and run binaries for both CPUs... not much of a usecase for me tho most likely
- There's also something called a "linux builder" which I won't explore for now

Now - there is only a two step process to updating your system.

1. Update the nix flake inputs
2. Rebuild the system

```bash
nix flake update
darwin-rebuild switch --flake .
```

Note that if the configuration resides in a git repository, `nix flake update --commit-lock-file` can automatically commit the lockfile changes! Cool.

Now, when you have your configuration in github, a new bootstrap from scratch looks as simple as

1. Install nix with the recommended installer
2. Run `nix run nix-darwin --switch --flake github:my-user/my-repo#my-config`
