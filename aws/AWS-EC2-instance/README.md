# Deploying an Application on AWS EC2

## Prerequisites
Before deploying your application on AWS EC2, ensure you have:
- An AWS account
- AWS CLI installed and configured (`aws configure`)
- SSH key pair (`.pem` file) for EC2 access
- A pre-built application ready for deployment

## Step 1: Launch an EC2 Instance
1. Log in to AWS Management Console.
2. Navigate to **EC2** > **Instances**.
3. Click **Launch Instance**.
4. Choose an Amazon Machine Image (AMI), e.g., **Amazon Linux 2**.
5. Select an instance type (e.g., `t2.micro` for free-tier eligibility).
6. Configure security group:
   - Allow **SSH (port 22)** for access.
   - Allow necessary ports (e.g., **80, 443 for web apps**).
7. Add a key pair for SSH access.
8. Launch the instance.

## Step 2: Connect to the EC2 Instance
```sh
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```

## Step 3: Update and Install Dependencies
```sh
sudo yum update -y   # Amazon Linux
sudo apt update -y   # Ubuntu/Debian

# Install required packages (example for a web app)
sudo yum install -y git nginx nodejs
```

## Step 4: Deploy Your Application
1. Clone your application repository:
   ```sh
   git clone https://github.com/your-repo/app.git
   cd app
   ```
2. Install dependencies:
   ```sh
   npm install  # For Node.js apps
   ```
3. Start the application:
   ```sh
   node server.js &
   ```

## Step 5: Configure Firewall and Security Group
Ensure your EC2 instance allows inbound traffic on required ports:
```sh
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload
```

Modify security group in AWS to allow necessary ports.

## Step 6: Set Up a Reverse Proxy (Optional)
For production deployments, use Nginx as a reverse proxy:
```sh
sudo nano /etc/nginx/nginx.conf
```
Configure the `server` block:
```nginx
server {
    listen 80;
    server_name your-ec2-public-ip;
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```
Restart Nginx:
```sh
sudo systemctl restart nginx
```

## Step 7: Enable Auto-Start (Optional)
Use **PM2** to keep your app running:
```sh
npm install -g pm2
pm2 start server.js
pm2 startup
pm2 save
```

## Step 8: Access Your Application
Visit `http://your-ec2-public-ip` in a browser.

## Conclusion
Your application is now live on AWS EC2! 🎉 For production, consider using **Elastic Load Balancing (ELB)** and **Auto Scaling** for better scalability.
