# libvirt k8s / kafka

# setup

```shell
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt

( cd terraform; terraform apply -auto-approve )
( cd ansible; ./playbook.yml )
export KUBECONFIG=$PWD/ansible/kubeconfig.yaml

kubectl apply -f http://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.0/deploy/longhorn.yaml
kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

kubectl create ns kafka
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka
kubectl apply -f kubernetes/kafka.yaml

kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.22.0-kafka-2.7.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list tom-kafka-bootstrap:9092 --topic my-topic
kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.22.0-kafka-2.7.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server tom-kafka-bootstrap:9092 --topic my-topic --from-beginning

```

# destroy

```shell
( cd terraform; terraform destroy -auto-approve )
```
