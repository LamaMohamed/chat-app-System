# Use the official Ruby image as a parent image
FROM ruby:3.3.3

# Set environment variables
ENV APP_ROOT /workspace
ENV LANG C.UTF-8 
ENV RAILS_ENV=development
ENV JEKYLL_CONCURRENCY=1

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
RUN  gem install bundler -v 2.5.14

# Build the application
RUN bundle install
RUN bundle exec jekyll build --limit-concurrent-jobs 1

# Create the working directory and set it as the current directory
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# Copy the current directory contents into the container
COPY . $APP_ROOT


# Expose port 3000 for the Rails server
EXPOSE 3000

# Define the command to run the application
CMD bin/rails db:create db:migrate && bin/rails server -b 0.0.0.0