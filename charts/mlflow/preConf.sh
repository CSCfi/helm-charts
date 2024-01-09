#!/bin/bash
RANDOM_PASS=$(openssl rand -base64 32 | tr -d '\n')
RANDOM_ADMIN_PASS=$(openssl rand -base64 32 | tr -d '\n')

cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: postgresql
  app: mlflow
type: Opaque
stringData:
  POSTGRESQL_USER: mlflow
  POSTGRESQL_PASSWORD: $RANDOM_PASS
  POSTGRESQL_DATABASE: mlflow_db
  POSTGRES_POSTGRES_PASSWORD: $RANDOM_ADMIN_PASS

---
apiVersion: v1
kind: Secret
metadata:
  name: mlflow-externaldb
  app: mlflow
type: Opaque
stringData:
  db-password: $RANDOM_PASS

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mlflow-postgresql-init-scripts
  app: mlflow
data:
  create_auth_db.sh: |
    #!/bin/bash
    PGPASSWORD=\$POSTGRES_POSTGRES_PASSWORD psql -U postgres <<< "CREATE DATABASE mlflow_auth;"
    PGPASSWORD=\$POSTGRES_POSTGRES_PASSWORD psql -U postgres <<< "GRANT ALL PRIVILEGES ON DATABASE mlflow_auth TO mlflow;"
    PGPASSWORD=\$POSTGRES_POSTGRES_PASSWORD psql -U postgres <<< "ALTER DATABASE mlflow_auth OWNER TO mlflow;"

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mlflow-postgresql
  app: mlflow
spec:
  selector:
    matchLabels:
      app: mlflow-postgresql
  template:
    metadata:
      labels:
        app: mlflow-postgresql
    spec:
      containers:
      - name: mlflow-postgresql
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          runAsNonRoot: true
          seccompProfile:
            type: RuntimeDefault
        image: bitnami/postgresql:latest
        resources:
          limits:
            cpu: 500m
            memory: 1Gi
          requests:
            cpu: 100m
            memory: 500Mi
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRESQL_USER
          valueFrom:
            secretKeyRef:
              key: POSTGRESQL_USER
              name: postgresql
        - name: POSTGRESQL_PASSWORD
          valueFrom:
            secretKeyRef:
              key: POSTGRESQL_PASSWORD
              name: postgresql
        - name: POSTGRESQL_DATABASE
          valueFrom:
            secretKeyRef:
              key: POSTGRESQL_DATABASE
              name: postgresql
        - name: POSTGRES_POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              key: POSTGRES_POSTGRES_PASSWORD
              name: postgresql

        volumeMounts:
        - mountPath: /var/lib/pgsql/data
          name: mlflow-db-data
        - mountPath: /docker-entrypoint-initdb.d/
          name: custom-init-scripts
      volumes:
      - name: mlflow-db-data
        persistentVolumeClaim:
          claimName: mlflow-pvc
      - name: custom-init-scripts
        configMap:
          name: mlflow-postgresql-init-scripts

---
apiVersion: v1
kind: Service
metadata:
  name: postgresql-svc
  app: mlflow
spec:
  selector:
    app: mlflow-postgresql
  ports:
  - port: 5432
    targetPort: 5432

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mlflow-pvc
  app: mlflow
spec:
  resources:
    requests:
      storage: 5Gi
  accessModes:
    - ReadWriteOnce
EOF
