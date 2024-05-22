# kubectl
Action for kubectl

## How To use
### Basic
```
- uses: Gabryel8818/kubectl@v1.0.5
  env:
    BASE64_KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_DATA }}
    KUBECTL_VERSION: '1.23.6'
  with:
    args: apply -f deployment.yaml -n argocd
```

### Matrix
```
name: Deploy applications
on:
  push:
    branches:
      - "main"

jobs:
  filesChanged:
    runs-on: ubuntu-20.04
    steps:
      - id: file_changes
        uses: trilom/file-changes-action@1.2.4

      - name: Get files
        id: files
        run: |
          content=$(jq ".[]" $HOME/files.json | grep projects | jq -R -s -c 'split("\n")[:-1]')
          echo "::set-output name=files::$content"
    outputs:
      files: ${{ steps.files.outputs.files }}

  apply:
    runs-on: ubuntu-20.04
    needs: [filesChanged]
    strategy:
      fail-fast: false
      matrix:
        file: ${{ fromJson(needs.filesChanged.outputs.files) }}
    steps:
      - name: Checkout
        id: checkout_code
        uses: actions/checkout@v3

      - name: AWS Credentials to EKS cluster
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
          role-to-assume: ${{ secrets.EKS_ROLE_TO_ASSUME }}
          role-duration-seconds: 900

      - uses: Gabryel8818/kubectl@v1.0.1
        env:
          BASE64_KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_DATA }}
          KUBECTL_VERSION: '1.23.6'
        with:
          args: apply -f ${{ matrix.file }} -n namespace
```
