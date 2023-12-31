## Spark Container Project
Github: https://github.com/harnetlinh/docker-spark.git
### Manual installation

1. Build Docker image

```
   cd containers && ./build-image.sh
```

2. Start container and run as the requirements

```
   cd containers && ./start-containers.sh <number slave> <size of the file to treat>
```

To go to the UI of the master node, go to http://localhost:8080

For example:

```
cd containers && ./start-containers.sh 2 10
```

3. Delete containers

```
   cd containers && ./kill-containers.sh
```

## Explanation

### Build Docker image

This Dockerfile sets up an Ubuntu-based environment configured for running Apache Spark and Hadoop, tailored for distributed computing. Key components include:

1. **Base Image**: Uses Ubuntu as the foundation.

2. **Shell Configuration**: Switches the default shell to `bash` for enhanced features.

3. **Environment Variables**: Sets paths for Java, Spark, and Hadoop, along with Hadoop-specific user settings.

4. **Dependencies**: Installs necessary packages like SSH server, Scala, wget, and tar.

5. **SSH Configuration**: Configures SSH for root access and disables strict host key checking, essential for cluster communication.

6. **File Copying**: Transfers SSH keys, configuration scripts, and Hadoop's `core-site.xml` for setup.

7. **Spark and Hadoop Installation**: Downloads and installs specific versions of Spark and Hadoop, ensuring compatibility.

8. **Script Setup**: Includes scripts for master and slave node operations, facilitating cluster management.

In summary, the Dockerfile creates a ready-to-use container for distributed data processing with Spark and Hadoop, focusing on ease of deployment and inter-node connectivity via SSH.

### Start container and run as the requirements

The `start-containers.sh` script automates the setup and management of a Docker-based Apache Spark cluster. Here's a brief explanation of its key operations:

1. **Environment Setup**:

   - `HERE` and `HAGIHOME` are environment variables storing current and parent directory paths.

2. **Parameter Handling**:

   - Accepts two parameters: `NUMBER_OF_SLAVE` (number of Spark slave nodes) and `FILE_SIZE` (for data processing).

3. **Network Creation**:

   - Creates a Docker network named `haginet`.

4. **Spark Master Container**:

   - Launches a Spark master container (`MASTER_CONTNAME`) with specific CPU allocation.
   - Maps necessary directories and files into the container, including JDK and `slave-info.txt`.
   - Starts the master node using `master-node.sh`.

5. **Spark Slave Containers**:

   - Populates `slave-info.txt` with slave container names (`slave1`, `slave2`, etc.).
   - For each slave node specified by `NUMBER_OF_SLAVE`, launches a slave container with its CPU allocation and required volume mappings.
   - Each slave node starts using `slave-node.sh`.

6. **Application Compilation**:

   - Executes `comp.sh` inside the master container to compile the Spark application (`WordCount.java`).

7. **Data Generation**:

   - Runs `generate.sh` to create a sample data file (`filesample.txt`) of specified `FILE_SIZE`.

8. **Data Distribution**:

   - Executes `copy.sh` to distribute the data file across the Spark cluster.

9. **Spark Job Execution**:

   - Runs the compiled Spark application using `run.sh`.

10. **Stopping the Cluster**:
    - Finally, executes `stop.sh` to gracefully stop the Spark cluster.

In summary, this script sets up a Docker-based Spark cluster, compiles and runs a Spark application, and manages the cluster's lifecycle, including data preparation and cleanup.

### Delete containers (kill-containers.sh)

The provided commands perform the following actions:

1. **Remove all Docker containers**: Deletes every Docker container on the system, regardless of their status (running or stopped).
2. **Remove Docker network**: Deletes the Docker network named `haginet`.
3. **Clear `slave-info.txt` file**: Empties the contents of the `slave-info.txt` file, which likely contains information about Spark slave nodes.

These steps are typically used for cleaning up after a Docker-based deployment, like resetting the environment after running a Spark cluster.

# Performance analysis
| Number of slave | Size of the file | Time in ms  | Time in ms (2nd times)  |
|-----------------|------------------|-------------|-------------------------|
| 1               | 10               |  27775      |       26173             |
| 2               | 10               |  66105      |       61825             |
| 1               | 05               |  25772      |       25331             |
| 2               | 05               |  58433      |       54267             |
| 3               | 05               |  60647      |       55262             |
| 4               | 05               |  41342      |       45588             |
| 5               | 05               |  38919      |       37598             |
| 6               | 05               |  35266      |       34743             |
| 2               | 20               | 320639      |      324893             |
| 3               | 20               | 380819      |      381014             |
| 4               | 20               | 354218      |      361293             |
| 5               | 20               | 343321      |      352211             |
| 6               | 20               | 340033      |      338415             |

The performance data from your file reveals key insights into the efficiency of a Spark-based word count task with varying numbers of slave nodes and file sizes (5GB, 10GB, 20GB):

- Scalability: Increasing the number of slave nodes generally decreases the task completion time, indicating good scalability. However, the reduction in time isn't linear, pointing to diminishing returns with more nodes.

- File Size Impact: Larger files consistently take longer to process. This highlights the direct impact of data volume on processing time.

- Efficiency Gains and Limits: The efficiency gained by adding more nodes varies, suggesting factors like network latency and task management overhead play a role.

- Optimal Configuration: There's a balance to be struck between performance gain and resource utilization, which the data can help identify.

These observations are crucial for understanding the practical performance of Spark in distributed computing, including how external factors like hardware configuration and network conditions can affect real-world results.

**Otherwise**
The number of slave nodes significantly impacts the performance of the Spark-based word count task:

- Incremental Benefit: The data shows that as the number of slaves increases, there is a decrease in processing time, but this benefit diminishes with more slaves.
- Resource Utilization: More slaves mean better resource utilization up to a point, beyond which additional nodes may not contribute as effectively.
- Overhead Concerns: With more slaves, there's increased overhead in coordination and data transfer, which can offset the gains from parallel processing.
- Optimal Number: There's an optimal number of slaves for each file size where performance gain is maximized, beyond which additional nodes add less value.





