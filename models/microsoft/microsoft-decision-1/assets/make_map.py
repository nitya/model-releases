"""Draw the Contoso Music Festival site map used in the capsule README and notebooks.

Run from this folder:  python make_map.py
"""
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import Circle, FancyBboxPatch, Polygon, Wedge

OUT = Path(__file__).with_name("contoso-music-festival-map.png")

BG, GROUND, PATH = "#F4F1EA", "#DCE8D0", "#FFFFFF"
INK = "#25303B"
ZONES = {
    "Main Stage": ("#E4572E", (4, 28, 26, 22)),
    "Lantern Stage": ("#7F3FBF", (64, 34, 24, 18)),
    "Food Court": ("#F2A541", (34, 10, 26, 16)),
    "Camping": ("#3E8E5A", (2, 2, 26, 20)),
    "Medical Tent": ("#D7263D", (64, 22, 11, 9)),
    "Info Desk": ("#2A7FBA", (39, 28, 14, 7)),
    "Shuttle Hub": ("#5C6B7A", (66, 4, 20, 12)),
}
GATES = {"Gate A": (46, 1.5), "Gate B": (92, 12)}

fig, ax = plt.subplots(figsize=(11, 6.4), dpi=130)
fig.patch.set_facecolor(BG)
ax.set_facecolor(GROUND)
ax.set_xlim(0, 100)
ax.set_ylim(-6, 68)
ax.set_aspect("equal")
ax.axis("off")

# Walkways
for xs, ys in [([30, 64], [39, 43]), ([46, 46], [4, 28]), ([28, 66], [14, 10]), ([52, 64], [31, 26])]:
    ax.plot(xs, ys, color=PATH, lw=9, solid_capstyle="round", zorder=1)

for name, (color, (x, y, w, h)) in ZONES.items():
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.4,rounding_size=1.6",
                                fc=color, ec="white", lw=2, alpha=0.92, zorder=2))
    ax.text(x + w / 2, y + h / 2, name.replace("Medical ", "Medical\n"), ha="center", va="center",
            color="white", fontsize=11, fontweight="bold", zorder=3)

# Stage fan on the Main Stage side
ax.add_patch(Wedge((17, 28), 7, 0, 180, fc="#B93E1F", ec="white", lw=1.5, zorder=2))

for name, (x, y) in GATES.items():
    ax.add_patch(Circle((x, y), 2.6, fc=INK, ec="white", lw=2, zorder=4))
    ax.text(x, y, name.split()[1], ha="center", va="center", color="white", fontsize=10,
            fontweight="bold", zorder=5)
    ax.text(x, y - 4.4 if y > 5 else y + 4.4, name, ha="center", va="center", color=INK,
            fontsize=9, zorder=5)

# Storm cell moving in from the north-west
ax.add_patch(Polygon([[0, 58], [38, 58], [28, 52], [8, 53]], fc="#5A6B7B", alpha=0.55, zorder=0))
ax.annotate("Storm cell, 18:05", xy=(24, 54), xytext=(44, 55), color=INK, fontsize=10,
            fontweight="bold", arrowprops=dict(arrowstyle="->", color=INK, lw=1.6), zorder=6)

ax.text(1, 67, "Contoso Music Festival: site map", fontsize=15, fontweight="bold", color=INK, va="top")
ax.text(1, 63, "A fictional site used by the Microsoft-Decision-1 capsule", fontsize=9.5, color=INK, va="top")

fig.savefig(OUT, bbox_inches="tight", facecolor=BG)
print("wrote", OUT)
