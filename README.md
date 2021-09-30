# ClinicoOmics Deployer
## Prerequisites
### Install Docker & Docker Compose

For Ubuntu

```bash
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
sudo apt-get update
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg \
     lsb-release
     
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose
```

### Install Miniconda

```bash
# Assumed to be installed in /opt/local/cobweb
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

### Install & Config Cromwell Server

```bash
# Create the conda configuration file
cat << EOF > ~/.condarc
channels:
  - conda-forge
  - defaults
  - bioconda
  - anaconda
  - fastai
  - pytorch
show_channel_urls: true
auto_activate_base: false
anaconda_upload: true
EOF

# Create a new environmet for cromwell
conda create -n cromwell-35 java-jdk=8.0.112

# Launch the mysql database for the cromwell server
wget http://nordata-cdn.oss-cn-shanghai.aliyuncs.com/clinico-omics/cromwell.zip
unzip cromwell.zip
cd cromwell
docker-compose up -d

# Get the customized cromwell-35 from ClinicoOmics Developer or download from the link
# wget http://nordata-cdn.oss-cn-shanghai.aliyuncs.com/clinico-omics/cromwell-35.tar.gz
mkdir /opt/local/cobweb/envs/cromwell-35/share/cromwell
tar -xzvf cromwell-35.tar.gz -C /opt/local/cobweb/envs/cromwell-35/share/cromwell

# Create a systemd service for cromwell
cat << EOF > /lib/systemd/system/cromwell-35.service
[Unit]
Description=Cromwell server daemon
After=network.target

[Service]
Type=simple
ExecStart=/opt/local/cobweb/envs/cromwell-35/bin/java -Xms512m -Xmx1g -Dconfig.file=/etc/cromwell-35.conf -jar /opt/local/cobweb/envs/cromwell-35/share/cromwell/cromwell.jar server
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
EOF

# Get the Cromwell configuration file from ClinicoOmics Developer or download from the link
wget http://nordata-cdn.oss-cn-shanghai.aliyuncs.com/clinico-omics/cromwell-35-local.conf
cp cromwell-35-local.conf /etc/cromwell-35.conf

# Launch the cromwell
systemctl start cromwell-35
```

## Quick Start

### Clone the Clinico Omics Deployer

```bash
git clone https://github.com/clinico-omics/clinico-omics-deployer
cd clinico-omics-deployer

pip3 install virtualenv
virtualenv .env
source .env/bin/activate
pip3 install -r requirements.txt
```

### Make a copy of the config.yml.template

```bash
cp config.yml.template custom/config.yml
```

### Modify the configuration file based on your situation

Please check the comments for more details in custom/config.yml.

### Initial the configuration files for services

```bash
./deployer init -c custom/config.yml
```

### Launch all services

```bash
# Firstly, launch the database
cd ./database
docker-compose up -d

# Secondly, launch the clinico-omics
cd ../clinico-omics
docker-compose up -d

# Lastly, launch the auth
cd ../auth
docker-compose up -d
```

### Configuration Auth Service

Access Keycloak Server by `http://<IP_ADDR>:8080/auth`.

After login, you need to click the import button and the import the `realm-export.json` from `./auth/config/` directory.

### Build Frontend

1. Clone the clinico-omics-studio
   
     ```bash
     git clone https://github.com/clinico-omics/clinico-omics-studio
     ```   

2. Open the `<clinico-omics-studio>/src/custom/clinico-omics/config.js` file
3. Modify the `apiService` variable based on the ip address of the server
4. Modify the `clientSecret` variable based on the value of the client_secret variable which you set in the `<clinico-omics-deployer>/custom/config.yml`
5. Build the clinico-omics-studio

     ```bash
     yarn && yarn build
     ```

6. Copy the frontend code into `<clinico-omics-deployer>/auth/nginx/clinico-omics` directory
7. Open your browser and access the `http://<IP_ADDR>`

## FAQs
