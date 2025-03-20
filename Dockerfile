FROM nixos/nix:latest

# Set environment variables
ENV USER=nixos
ENV HOME=/home/$USER
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

# Install necessary tools
RUN nix-env -iA nixpkgs.git nixpkgs.fish nixpkgs.ripgrep nixpkgs.wget \
    && nix-env -iA nixpkgs.gnused nixpkgs.findutils nixpkgs.coreutils

# Create user manually without useradd (which isn't available)
RUN mkdir -p $HOME \
    && echo "$USER:x:1000:1000:$USER,,,:/home/$USER:/bin/sh" >> /etc/passwd \
    && echo "$USER:x:1000:" >> /etc/group \
    && chown -R 1000:1000 $HOME

# Create workspace directories
RUN mkdir -p /etc/nixos $HOME/.config

# Copy nixos configuration files
COPY nixos/ /etc/nixos/
COPY home/ $HOME/

# Set ownership
RUN chown -R 1000:1000 $HOME \
    && chown -R 0:0 /etc/nixos

# Configure flakes support
RUN mkdir -p /etc/nix \
    && echo 'experimental-features = nix-command flakes' > /etc/nix/nix.conf

# Install starship prompt for fish
RUN nix-env -iA nixpkgs.starship \
    && mkdir -p $HOME/.config/fish \
    && echo 'starship init fish | source' >> $HOME/.config/fish/config.fish

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to the user
USER 1000
WORKDIR $HOME

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh"] 