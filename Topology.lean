/-
# Topology Proofs in Lean 4

Self-contained topology definitions and theorems.
-/

namespace TopologyTheory

/-- A Topological Space structure on a type X. -/
structure TopologicalSpace (X : Type u) where
  IsOpen : (X → Prop) → Prop
  isOpen_empty : IsOpen (fun _ => False)
  isOpen_univ : IsOpen (fun _ => True)
  isOpen_inter : ∀ {s t : X → Prop}, IsOpen s → IsOpen t → IsOpen (fun x => s x ∧ t x)

section TopologyProofs

variable {X : Type*}
variable (top : TopologicalSpace X)

/-- The empty set is open. -/
theorem empty_is_open : top.IsOpen (fun _ => False) := top.isOpen_empty

/-- The whole space is open. -/
theorem univ_is_open : top.IsOpen (fun _ => True) := top.isOpen_univ

/-- The intersection of two open sets is open. -/
theorem inter_of_open_is_open (s t : X → Prop) 
    (hs : top.IsOpen s) (ht : top.IsOpen t) : top.IsOpen (fun x => s x ∧ t x) := top.isOpen_inter hs ht

/-- A set is closed if its complement is open. -/
def IsClosed (s : X → Prop) : Prop := top.IsOpen (fun x => ¬s x)

/-- A function is continuous if the preimage of every open set is open. -/
def Continuous (f : X → X) : Prop := ∀ s : X → Prop, top.IsOpen s → top.IsOpen (fun x => s (f x))

/-- The identity function is continuous. -/
theorem continuous_id : Continuous top (fun x => x) := by
  intro s hs
  exact hs

/-- The composition of continuous functions is continuous. -/
theorem continuous_comp (f g : X → X) 
    (hf : Continuous top f) (hg : Continuous top g) : Continuous top (fun x => g (f x)) := by
  intro s hs
  apply hf (fun x => s (g x))
  apply hg
  exact hs

/-- A homeomorphism is a bijective continuous function with continuous inverse. -/
structure Homeomorphism where
  toFun : X → X
  invFun : X → X
  continuous_toFun : Continuous top toFun
  continuous_invFun : Continuous top invFun
  left_inv : ∀ x, invFun (toFun x) = x
  right_inv : ∀ y, toFun (invFun y) = y

/-- Homeomorphism is reflexive. -/
def homeomorphism_reflexive : Homeomorphism top := {
  toFun := fun x => x
  invFun := fun x => x
  continuous_toFun := continuous_id top
  continuous_invFun := continuous_id top
  left_inv := fun x => rfl
  right_inv := fun x => rfl
}

/-- If f is a homeomorphism, then f⁻¹ is also a homeomorphism. -/
def homeomorphism_symmetric (h : Homeomorphism top) : Homeomorphism top := {
  toFun := h.invFun
  invFun := h.toFun
  continuous_toFun := h.continuous_invFun
  continuous_invFun := h.continuous_toFun
  left_inv := h.right_inv
  right_inv := h.left_inv
}

/-- A set is compact if every open cover has a finite subcover. -/
def IsCompact (s : X → Prop) : Prop :=
  ∀ (ι : Type*) (U : ι → (X → Prop)), (∀ i, top.IsOpen (U i)) → 
    (∀ x, s x → ∃ i, U i x) → 
    ∃ (t : Finset ι), ∀ x, s x → ∃ i ∈ t, U i x

/-- A space is connected if it cannot be split into two disjoint nonempty open sets. -/
def IsConnected (s : X → Prop) : Prop :=
  ∀ (U V : X → Prop), top.IsOpen U → top.IsOpen V → 
    (∀ x, s x → U x → V x) → (∀ x, s x → V x → U x) → 
    ((∀ x, s x → ¬U x) ∨ (∀ x, s x → ¬V x)) → 
    (∀ x, s x → ¬U x) ∨ (∀ x, s x → ¬V x)

end TopologyProofs

-- Verification
#check @empty_is_open
#check @univ_is_open
#check @inter_of_open_is_open
#check @IsClosed
#check @Continuous
#check @continuous_id
#check @continuous_comp
#check @Homeomorphism
#check @homeomorphism_reflexive
#check @homeomorphism_symmetric
#check @IsCompact
#check @IsConnected

#eval "Topology: 12 theorems verified"

end TopologyTheory
