# Labels & Selectors

Are a standard method to group things together.

Act as filters when used with selectors.

For example:
```sh
# Run a Pod with specific labels.
k run --image nginx --labels app=App1 nginx

# Filter that Pod by the same labels.
k get po --selector app=App1 nginx
```