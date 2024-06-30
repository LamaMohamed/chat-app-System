# Use the official Ruby image as a parent image
FROM ruby:3.3.3

# Set environment variables
ENV APP_ROOT /workspace
ENV LANG C.UTF-8

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs \
    vim \
    default-mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/.deb /var/cache/apt/archives/partial/.deb /var/cache/apt/*.bin || true

# Set the working directory to /tmp for caching the bundle install
WORKDIR /tmp

# Add the Gemfile and Gemfile.lock to the /tmp directory
COPY Gemfile Gemfile.lock ./

# Run bundle install to install gems
RUN bundle install

# Create the working directory and set it as the current directory
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Copy the current directory contents into the container
COPY . $APP_ROOT

# Expose port 3000 for the Rails server
EXPOSE 3000

# Define the command to run the application
CMD ["bash", "-c", "rails db:migrate:reset && rm -f tmp/pids/server.pid && rails s -b '0.0.0.0'"]