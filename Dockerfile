# Use the official Node.js image as a base
FROM node:18-alpine

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Install git and openssh (Alpine uses apk, not apt-get)
RUN apk update && apk add --no-cache git openssh

# Create the .ssh directory and set permissions
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy the private SSH key and set permissions
# Ensure you have `id_rsa` in the same directory as your Dockerfile
COPY id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Add GitHub to known hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Clone the private GitHub repository
RUN git clone git@github.com:logeswaran-inoesis/myheloapplication.git /usr/src/app/myheloapplication

# Change to the cloned repository directory
WORKDIR /usr/src/app/myheloapplication

# Ensure that the cloned repository's dependencies are installed
RUN npm install

# Build the Next.js application
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]



# the docker file is using the ssh of the next js application correct fort 
# FROM node:18-alpine

# # Create and change to the app directory
# WORKDIR /usr/src/app

# # Install git, openssh, and openssl (Alpine uses apk, not apt-get)
# RUN apk update && apk add --no-cache git openssh openssl

# # Create the .ssh directory and set permissions
# RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# # Copy the private SSH key and set permissions
# COPY id_rsa /root/.ssh/id_rsa
# RUN chmod 600 /root/.ssh/id_rsa

# # Add GitHub to known hosts
# RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# # Clone the private GitHub repository
# RUN git clone git@github.com:inoesis/quickans.ai_frontend.git /usr/src/app/QuickAns.ai_Frontend

# # Change to the cloned repository directory
# WORKDIR /usr/src/app/QuickAns.ai_Frontend

# # Checkout the 'sidebar' branch
# RUN git checkout sidebar

# # Ensure that the cloned repository's dependencies are installed
# RUN npm install

# # Build the Next.js app
# RUN npm run build

# # Set environment variables
# ENV NODE_ENV=production

# # Generate a random base64 encoded string and save it to a file
# RUN openssl rand -base64 32 > /root/random_string.txt

# # Use the generated secret in the CMD instruction
# CMD NEXTAUTH_SECRET=$(cat /root/random_string.txt) npm start

# # Expose the port the app runs on
# EXPOSE 3000
