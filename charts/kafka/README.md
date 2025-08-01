# Apache Kafka

## TL;DR

```sh
helm upgrade --install kafka .
```

## Explanations

> [Helm](helm.sh) and `oc` CLI must be installed on your local machine.

This Helm Chart helps you to deploy Kafka on CSC Rahti (Openshift 4). Default upstream [values.yaml](https://github.com/bitnami/charts/blob/main/bitnami/kafka/values.yaml) is being used. If you want to use it with different values, you can download the [values.yaml](https://github.com/CSCfi/helm-charts/blob/main/charts/elastic-kibana/values.yaml) file and then run:

  ```sh
  helm upgrade --install elastic-kibana . -f {custom_values.yaml}
  ```

You can checkout the upstream [README.md](https://github.com/bitnami/charts/blob/main/bitnami/kafka/README.md) file for reference on configuration options.

## Quick testing

1. Create a client Pod:

    ```sh
    kubectl run kafka-client --restart='Never' \
      --image docker.io/bitnami/kafka:4.0.0-debian-12-r8 --command -- \
      sleep infinity
    ```

1. Create a client.properties file:

    ```sh
    echo "security.protocol=SASL_PLAINTEXT
    sasl.mechanism=SCRAM-SHA-256
    sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
        username="user1" \
        password="$(kubectl get secret {{ .Release.Name }}-user-passwords --namespace test-kafka \
        -o jsonpath='{.data.client-passwords}' | base64 -d | cut -d , -f 1)";
    " >client.properties
    ```

1. Copy the configuration to the Pod:

    ```sh
    kubectl cp --namespace test-kafka ./client.properties \
      kafka-client:/tmp/client.properties
    ```

1. Connect to the Pod, run a producer and send some test message:
    
    ```sh
    kubectl exec --tty -i my-release-kafka-client --namespace test-kafka -- \
      kafka-console-producer.sh \
                --producer.config /tmp/client.properties \
                --bootstrap-server my-release-kafka.test-kafka.svc.cluster.local:9092 \
                --topic test
    >
    ```

1. Connect to the same Pod, run a consumer, and see the messages:

    ```sh
    kubectl exec --tty -i my-release-kafka-client --namespace test-kafka -- \
      kafka-console-consumer.sh \
                --consumer.config /tmp/client.properties \
                --bootstrap-server my-release-kafka.test-kafka.svc.cluster.local:9092 \
                --topic test \
                --from-beginning
    ```

Any text message that you send in the "producer" will appear in the "consumer". You can keep both process running at the same time and see the messages flowing.

## Cleanup
To delete all the resources, simply uninstall the Helm Chart:
```sh
helm uninstall hedgedoc
```

