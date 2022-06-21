# jupyterlab-livy-spark
Jupyterlab with spark kernel (integrated via livy and sparkmagic)

# Pre-requisites
Docker and docker-compose should be installed

# Build steps
Clone the repo, and run the build.sh file. This will create an image jupyterlab-with-spark:latest and will start the container.
[Note: Image can also be directly downloaded by 'docker pull senchandra/jupyterlab-with-spark'. If using this, change the image in docker-compose.yml from jupyterlab-with-spark to senchandra/jupyterlab-with-spark]

# List of programs running
1. Spark standalone cluster manager (Master and slave). Spark UI at port 8080 and spark master at spark://127.0.1.1:7077
2. Livy (Running on port 8889)
3. Jupyterlab (Running on port 8888)

# Running the Spark kernel on Notebook
1. Open jupyterlab at localhost:8888. It does not require password or token.
2. Select either of the kernel pyspark, sparkr or sparkshell and create a new notebook.
3. Type 'spark' in the cell and run the cell in Notebook. The spark session gets created and gets registered in livy as well as Spark Clustermanager.
