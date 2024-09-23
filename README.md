# Containerizing_WebApp
Containerization and container orchestration

# setup your project
#create a new project directory
cd ~/Documents
mkdir my-web-app
cd my-web-app

# inside the directory create an HTML file (index.html) and a CSS file (styles.css)
touch index.html
touch style.css

# Initialize Git
git init

# Git commit
git add .
git commit -m "Initial commit with basic HTML and CSS"

# Dockerize the application
touch Dockerfile
nano Dockerfile

# Use the official Nginx image from the Docker Hub
FROM nginx:alpine

# Set the working directory inside the container
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy the HTML and CSS files from the local directory to the Nginx directory
COPY index.html .
COPY styles.css .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]

# Build the Docker image (replace "my-web-app" with your preferred image name)
docker build -t my-web-app .

# push to docker hub
docker login
docker push TOBI/my-web-app:latest

# Setup a kind kubernetes cluster
choco install kind
kind create cluster

# Deploy to kubernetes
vim deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-web-app:latest
        ports:
        - containerPort: 80
# Apply deployment to cluster
kubectl apply -f deployment.yaml
kubectl get deployments

# create a service (clusterIP)
vim service.yaml

apiVersion: v1
kind: Service
metadata:
  name: my-app-service
  labels:
    app: my-app
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 80

# Apply service to cluster
kubectl apply -f service.yaml
kubectl get services

# Access the application
kubectl port-forward service/my-app-service 8080:80
