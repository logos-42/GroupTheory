/-
# Group Theory Proofs in Lean 4

Self-contained group theory proofs without external dependencies.
-/

namespace GroupTheory

/-- A Group structure on a type G. -/
structure GroupStruct (G : Type u) where
  mul : G → G → G
  one : G
  inv : G → G
  mul_assoc : ∀ a b c : G, mul (mul a b) c = mul a (mul b c)
  one_mul : ∀ a : G, mul one a = a
  mul_one : ∀ a : G, mul a one = a
  inv_mul : ∀ a : G, mul (inv a) a = one
  mul_inv : ∀ a : G, mul a (inv a) = one

section GroupProofs

variable {G : Type}
variable (grp : GroupStruct G)

/-- The identity element is unique in a group. -/
theorem identity_unique (e₁ e₂ : G) 
    (h₁ : ∀ a : G, grp.mul e₁ a = a ∧ grp.mul a e₁ = a)
    (h₂ : ∀ a : G, grp.mul e₂ a = a ∧ grp.mul a e₂ = a) : 
    e₁ = e₂ := by
  have h₃ := h₁ e₂
  have h₄ := h₂ e₁
  -- h₃ : grp.mul e₁ e₂ = e₂ ∧ grp.mul e₂ e₁ = e₂
  -- h₄ : grp.mul e₂ e₁ = e₁ ∧ grp.mul e₁ e₂ = e₁
  have h₅ : e₁ = grp.mul e₁ e₂ := by
    have : grp.mul e₁ e₂ = e₁ := h₄.2
    rw [this]
  have h₆ : grp.mul e₁ e₂ = e₂ := h₃.1
  rw [h₅, h₆]

/-- The inverse of an element is unique in a group. -/
theorem inverse_unique (a b c : G) 
    (h₁ : grp.mul a b = grp.one ∧ grp.mul b a = grp.one)
    (h₂ : grp.mul a c = grp.one ∧ grp.mul c a = grp.one) : 
    b = c := by
  have h₃ : b = grp.mul b grp.one := by rw [grp.mul_one]
  have h₄ : grp.mul b grp.one = grp.mul b (grp.mul a c) := by rw [h₂.1]
  have h₅ : grp.mul b (grp.mul a c) = grp.mul (grp.mul b a) c := by rw [grp.mul_assoc]
  have h₆ : grp.mul (grp.mul b a) c = grp.mul grp.one c := by rw [h₁.2]
  have h₇ : grp.mul grp.one c = c := by rw [grp.one_mul]
  rw [h₃, h₄, h₅, h₆, h₇]

/-- The inverse of the inverse is the original element. -/
theorem inv_inv_eq_self (a : G) : grp.inv (grp.inv a) = a := by
  have h₁ : grp.mul (grp.inv a) a = grp.one := grp.inv_mul a
  have h₂ : grp.mul a (grp.inv a) = grp.one := grp.mul_inv a
  have h₃ : grp.mul (grp.inv a) (grp.inv (grp.inv a)) = grp.one := grp.mul_inv (grp.inv a)
  have h₄ : grp.mul (grp.inv (grp.inv a)) (grp.inv a) = grp.one := grp.inv_mul (grp.inv a)
  have h₅ : grp.inv (grp.inv a) = grp.mul (grp.inv (grp.inv a)) grp.one := by rw [grp.mul_one]
  have h₆ : grp.mul (grp.inv (grp.inv a)) grp.one = grp.mul (grp.inv (grp.inv a)) (grp.mul (grp.inv a) a) := by rw [h₁]
  have h₇ : grp.mul (grp.inv (grp.inv a)) (grp.mul (grp.inv a) a) = grp.mul (grp.mul (grp.inv (grp.inv a)) (grp.inv a)) a := by rw [grp.mul_assoc]
  have h₈ : grp.mul (grp.mul (grp.inv (grp.inv a)) (grp.inv a)) a = grp.mul grp.one a := by rw [h₄]
  have h₉ : grp.mul grp.one a = a := by rw [grp.one_mul]
  rw [h₅, h₆, h₇, h₈, h₉]

/-- The inverse of a product. -/
theorem inv_mul_eq_inv_inv_mul (a b : G) : 
    grp.inv (grp.mul a b) = grp.mul (grp.inv b) (grp.inv a) := by
  have h₁ : grp.mul (grp.mul a b) (grp.mul (grp.inv b) (grp.inv a)) = grp.one := by
    calc
      grp.mul (grp.mul a b) (grp.mul (grp.inv b) (grp.inv a)) 
        = grp.mul a (grp.mul b (grp.mul (grp.inv b) (grp.inv a))) := by rw [grp.mul_assoc]
      _ = grp.mul a (grp.mul (grp.mul b (grp.inv b)) (grp.inv a)) := by rw [grp.mul_assoc]
      _ = grp.mul a (grp.mul grp.one (grp.inv a)) := by rw [grp.mul_inv]
      _ = grp.mul a (grp.inv a) := by rw [grp.one_mul]
      _ = grp.one := by rw [grp.mul_inv]
  have h₂ : grp.mul (grp.mul (grp.inv b) (grp.inv a)) (grp.mul a b) = grp.one := by
    calc
      grp.mul (grp.mul (grp.inv b) (grp.inv a)) (grp.mul a b)
        = grp.mul (grp.inv b) (grp.mul (grp.inv a) (grp.mul a b)) := by rw [grp.mul_assoc]
      _ = grp.mul (grp.inv b) (grp.mul (grp.mul (grp.inv a) a) b) := by rw [grp.mul_assoc]
      _ = grp.mul (grp.inv b) (grp.mul grp.one b) := by rw [grp.inv_mul]
      _ = grp.mul (grp.inv b) b := by rw [grp.one_mul]
      _ = grp.one := by rw [grp.inv_mul]
  have h₃ : grp.inv (grp.mul a b) = grp.mul (grp.inv b) (grp.inv a) := by
    have h₄ := inverse_unique grp (grp.mul a b) (grp.mul (grp.inv b) (grp.inv a)) (grp.inv (grp.mul a b)) ⟨h₁, h₂⟩ ⟨by rw [grp.mul_inv], by rw [grp.inv_mul]⟩
    rw [h₄]
  exact h₃

/-- Left cancellation law. -/
theorem mul_left_cancel' (a b c : G) : grp.mul a b = grp.mul a c → b = c := by
  intro h
  have h₁ : b = grp.mul grp.one b := by rw [grp.one_mul]
  have h₂ : grp.mul grp.one b = grp.mul (grp.mul (grp.inv a) a) b := by rw [grp.inv_mul]
  have h₃ : grp.mul (grp.mul (grp.inv a) a) b = grp.mul (grp.inv a) (grp.mul a b) := by rw [grp.mul_assoc]
  have h₄ : grp.mul (grp.inv a) (grp.mul a b) = grp.mul (grp.inv a) (grp.mul a c) := by rw [h]
  have h₅ : grp.mul (grp.inv a) (grp.mul a c) = grp.mul (grp.mul (grp.inv a) a) c := by rw [grp.mul_assoc]
  have h₆ : grp.mul (grp.mul (grp.inv a) a) c = grp.mul grp.one c := by rw [grp.inv_mul]
  have h₇ : grp.mul grp.one c = c := by rw [grp.one_mul]
  rw [h₁, h₂, h₃, h₄, h₅, h₆, h₇]

/-- Right cancellation law. -/
theorem mul_right_cancel' (a b c : G) : grp.mul b a = grp.mul c a → b = c := by
  intro h
  have h₁ : b = grp.mul b grp.one := by rw [grp.mul_one]
  have h₂ : grp.mul b grp.one = grp.mul b (grp.mul a (grp.inv a)) := by rw [grp.mul_inv]
  have h₃ : grp.mul b (grp.mul a (grp.inv a)) = grp.mul (grp.mul b a) (grp.inv a) := by rw [grp.mul_assoc]
  have h₄ : grp.mul (grp.mul b a) (grp.inv a) = grp.mul (grp.mul c a) (grp.inv a) := by rw [h]
  have h₅ : grp.mul (grp.mul c a) (grp.inv a) = grp.mul c (grp.mul a (grp.inv a)) := by rw [grp.mul_assoc]
  have h₆ : grp.mul c (grp.mul a (grp.inv a)) = grp.mul c grp.one := by rw [grp.mul_inv]
  have h₇ : grp.mul c grp.one = c := by rw [grp.mul_one]
  rw [h₁, h₂, h₃, h₄, h₅, h₆, h₇]

/-- The identity element is its own inverse. -/
theorem inv_one_eq_one : grp.inv grp.one = grp.one := by
  have h : grp.mul grp.one grp.one = grp.one := grp.one_mul grp.one
  have h_inv : grp.mul (grp.inv grp.one) grp.one = grp.one := grp.inv_mul grp.one
  have h₁ : grp.inv grp.one = grp.mul (grp.inv grp.one) grp.one := by rw [grp.mul_one]
  have h₂ : grp.mul (grp.inv grp.one) grp.one = grp.mul (grp.inv grp.one) (grp.mul grp.one grp.one) := by rw [h]
  have h₃ : grp.mul (grp.inv grp.one) (grp.mul grp.one grp.one) = grp.mul (grp.mul (grp.inv grp.one) grp.one) grp.one := by rw [grp.mul_assoc]
  have h₄ : grp.mul (grp.mul (grp.inv grp.one) grp.one) grp.one = grp.mul grp.one grp.one := by rw [h_inv]
  have h₅ : grp.mul grp.one grp.one = grp.one := by rw [grp.one_mul]
  rw [h₁, h₂, h₃, h₄, h₅]

/-- Product with identity. -/
theorem mul_id (a : G) : grp.mul a grp.one = a ∧ grp.mul grp.one a = a := by
  constructor
  · apply grp.mul_one
  · apply grp.one_mul

end GroupProofs

-- Verification
#check @identity_unique
#check @inverse_unique
#check @inv_inv_eq_self
#check @inv_mul_eq_inv_inv_mul
#check @mul_left_cancel'
#check @mul_right_cancel'
#check @inv_one_eq_one
#check @mul_id

#eval "Group Theory: 8 theorems verified"

end GroupTheory
