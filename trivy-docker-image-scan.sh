dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

chown -R jenkins.jenkins trivy
## Trivy Scan result procsessing

exit_code=$?

# Check scan results
if [[ "${exit_code}" == 1 ]]; then
	echo "Image Scanning failed. Vulnerabilities found Critical"
	exit 1;
else
	echo "Image Scanning passed. No Vulnerabilities found"
fi

