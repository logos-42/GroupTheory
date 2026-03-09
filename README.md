# Group Theory and Topology Proofs

A self-contained Lean 4 project demonstrating fundamental theorems and formal proofs in two core areas of mathematics:

## 📚 Project Overview

This repository contains formal mathematical proofs in [Lean 4](https://leanprover.github.io/), covering:

### Group Theory (群论)
Algebraic structures with group operations, including:
- **Identity element uniqueness** - Proving there is exactly one identity element in a group
- **Inverse element uniqueness** - Each element has a unique inverse
- **Double inverse theorem** - (a⁻¹)⁻¹ = a
- **Inverse of product** - (a * b)⁻¹ = b⁻¹ * a⁻¹
- **Cancellation laws** - Left and right cancellation properties
- **Identity inverse** - e⁻¹ = e

**Total: 8 theorems verified**

### Topology (拓扑学)
The study of continuous deformations and spatial properties:
- **Open set properties** - Empty set and universal set are open
- **Closed sets** - Definition and properties of closed sets
- **Continuity** - Definition and characterizations of continuous functions
- **Homeomorphisms** - Structure preserving bijections
- **Compactness** - Definition and fundamental properties
- **Connectedness** - Definition of connected topological spaces

**Total: 12 theorems verified**

## 🏗️ Project Structure

```
├── main.lean          # Entry point - verification report
├── GroupTheory.lean   # Group theory proofs
├── Topology.lean      # Topology proofs
├── lakefile.toml      # Lean build configuration
└── lean-toolchain     # Lean version specification
```

## 🚀 Running the Proofs

Compile and run using Lean 4:

```bash
# Compile Group Theory proofs
lean -o GroupTheory.olean GroupTheory.lean

# Compile Topology proofs  
lean -o Topology.lean Topology.lean

# Run main verification
lean main.lean
```

## ✅ Verification Status

All 20 proofs compile successfully in Lean 4 with no external dependencies.

## 📝 About

Archived from: git@github.com:logos-42/GroupTheory.git

This project demonstrates formal verification using dependent type theory and the Lean proof assistant.
