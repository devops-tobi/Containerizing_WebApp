# Use the official Nginx image from the Docker Hub
FROM nginx:alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy the HTML and CSS files from the local directory to the Nginx directory
COPY indexproject.html .
COPY styleproject.css .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
