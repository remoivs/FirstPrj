pipeline {
    agent none
    stages {
        
        stage('Install and configure puppet agent on the slave node') {
            agent { label 'slave'}
            steps {
                echo 'Install Puppet'
                sh "wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb"
                sh "sudo dpkg -i puppetlabs-release-pc1-xenial.deb"
                sh "sudo apt-get update"
                sh "sudo apt-get install puppet-agent"
            }
        }

        stage('Start puppet') {
            agent { label 'slave'}
            steps {
                echo 'start puppet'
                sh "sudo systemctl start puppet"
                sh "sudo systemctl enable puppet"
            }
        }

        stage('Trigger the puppet agent on test server to install docker') {
            agent{ label 'slave'}
            steps {
                sh "sudo /opt/puppetlabs/bin/puppet module install garethr-docker"
            }
        }

        stage('Pull files from Git-checkout') {
            agent{ label 'slave'}
            steps {
                sh "git clone https://github.com/remoivs/FirstPrj.git /home/jenkins/jenkins_slave/workspace/Certification "
                sh "sudo /opt/puppetlabs/bin/puppet apply /home/jenkins/jenkins_slave/workspace/Certification/dockerce.pp"
                sh "cd /home/jenkins/jenkins_slave/workspace/Certification && sudo git checkout master"
            }
        }
        
        stage('Docker Build and Run') {
            agent{ label 'slave'}
            steps {
                sh "sudo docker rm -f webapp || true"
                sh "cd /home/jenkins/jenkins_slave/workspace/Certification && sudo docker build -t test ."
                sh "sudo docker run -it -d --name webapp -p 8080:80 test"
            }
        }

		stage('Setting Prerequisite for Selenium') {
            agent{ label 'slave'}
            steps {
                sh "wget -N -O 'firefox-57.0.tar.bz2' http://ftp.mozilla.org/pub/firefox/releases/57.0/linux-x86_64/en-US/firefox-57.0.tar.bz2"
				sh "tar -xjf firefox-57.0.tar.bz2"
				sh "rm -rf /opt/firefox"
				sh "sudo mv firefox /opt/"
				sh "sudo mv /usr/bin/firefox /usr/bin/firefox_old"
				sh "sudo ln -s /opt/firefox/firefox /usr/bin/firefox"
            }
        }

        stage('Check if selenium test run') {
            agent{ label 'slave'}
            steps {
		sh "cd /home/jenkins/jenkins_slave/workspace/Certification/"
		sh "java -jar certification-project-1.0-SNAPSHOT-jar-with-dependencies.jar --headless"
            	}
            post {
                failure {
                    sh "echo Failure"
					sh "sudo docker rm -f webapp"
                }
			}
		}
	}
}
