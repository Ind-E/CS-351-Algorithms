import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

df = pd.read_csv("data.csv")

n = df["n"].to_numpy()
runtime = df["avg_time_ns"].to_numpy()
ops = df["avg_operations"].to_numpy()

c_time, *_ = np.linalg.lstsq((n**3).reshape(-1, 1), runtime, rcond=None)
c_ops, *_ = np.linalg.lstsq((n**3).reshape(-1, 1), ops, rcond=None)

# --- Runtime plot ---
plt.figure(figsize=(8, 6))
plt.plot(n, runtime, "o-", label="Runtime")
plt.plot(n, c_time * n**3, "--", label="O(n³) fit")
plt.xlabel("Input size (n)")
plt.ylabel("Runtime (ns)")
plt.title("Input size vs Runtime")
plt.legend()
plt.grid(True)

plt.savefig("runtime.png")

plt.xscale("log")
plt.yscale("log")
plt.title("Input size vs Runtime (Log-Log)")

plt.savefig("runtime-log.png")

plt.close()

# --- Operations plot ---
plt.figure(figsize=(8, 6))
plt.plot(n, ops, "o-", label="Operations")
plt.plot(n, c_ops * n**3, "--", label="O(n³) fit")
plt.xlabel("Input size (n)")
plt.ylabel("Operations")
plt.title("Input size vs Operations")
plt.legend()
plt.grid(True)

plt.savefig("operations.png")

plt.xscale("log")
plt.yscale("log")
plt.title("Input size vs Operations (Log-Log)")

plt.savefig("operations-log.png")
