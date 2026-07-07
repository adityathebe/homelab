# Pod stuck Terminating

If a pod is stuck in `Terminating`, try restarting k3s on the node running it:

```bash
ssh <node>
sudo systemctl restart k3s-node.service
# fallback: sudo systemctl restart k3s-agent.service
```

This can also release stale GPU/device/DRA claims held by the terminating pod.

Do not force-delete/patch Flux-managed resources unless explicitly approved.
