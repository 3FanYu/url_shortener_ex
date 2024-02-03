# Use the official Elixir image as a parent image
FROM elixir:latest

# Install hex package manager
RUN mix local.hex --force && \
    mix local.rebar --force

# Create and set the working directory
WORKDIR /app

# Set and expose the port
EXPOSE 4000

# Copy the mix.exs and mix.lock files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get

# Copy the rest of your application's code
COPY . .

# Compile the project
RUN mix do compile

# Run the Phoenix server
CMD ["mix", "phx.server"]
