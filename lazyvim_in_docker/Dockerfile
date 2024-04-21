FROM ubuntu:22.04 

# Update package lists for efficient installation
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  file \
  git \
  unzip \
  ruby-full \
  fontconfig \
  locales

# Set UTF-8 locale to avoid brew warnings
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Create a non-root user for Homebrew installation (security best practice)
RUN useradd -m -s /bin/bash linuxbrew && \
  chown -R linuxbrew:linuxbrew /usr/share/fonts

# Grant sudo privileges to the linuxbrew user for installation (temporary)
RUN echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to the linuxbrew user for installation
USER linuxbrew

# Install Homebrew using the official script
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# Cleanup sudoers file entry (security best practice)
# RUN echo '# Removed temporary sudoers entry for linuxbrew' >> /etc/sudoers && \
# sed '/linuxbrew ALL=(ALL) NOPASSWD:ALL/d' -i /etc/sudoers

# Set the PATH environment variable to include Homebrew binaries (optional)
ENV PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# RUN brew install neovim && \
RUN brew install neovim ripgrep xsel fd && \
  brew autoremove -v && \
  brew cleanup

# Rebuild font cache
RUN curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip -o /tmp/0xProto.zip && \
  unzip /tmp/0xProto.zip -d /usr/share/fonts && \
  fc-cache -fv

# Clone LazyVim starter repository into ~/.config/nvim
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim && \
  rm -rf ~/.config/nvim/.git

RUN nvim --headless +PlugInstall +qall

# Optional: Set a working directory (replace with your desired path)
WORKDIR /app

