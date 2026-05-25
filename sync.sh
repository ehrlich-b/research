#!/bin/bash
# Sync public research repo from private sources.
# Sources:
#   ~/repos/blog/landing/papers/                   -> papers/
#   ~/scratch/get-physics-done/derivations/        -> derivations/
#   ~/scratch/get-physics-done/code/               -> verification/
#   ~/repos/blog/research/self-modeling-constants/ -> experiments/
#
# Run from the research repo root, then: git add -A && git commit && git push
#
# NOTE ON RENAMES: rsync --delete only cleans WITHIN each synced dir; it does
# not remove a whole superseded paper dir or a renamed loose file. When a paper
# is renamed/superseded (e.g. spacetime-from-self-modeling -> gr-from-self-modeling,
# experiential-measure-2026 -> h_3_O-measure-2026), `git rm` the stale path by hand.

set -euo pipefail

BLOG="$HOME/repos/blog"
GPD="$HOME/scratch/get-physics-done"
HERE="$(cd "$(dirname "$0")" && pwd)"

cd "$HERE"

echo "Syncing papers..."
# Current paper directories (Paper 5 / 6 / 7 / 0).
for dir in qm-from-self-modeling gr-from-self-modeling sm-from-self-modeling radical-relativity; do
    if [ ! -d "$BLOG/landing/papers/$dir" ]; then
        echo "  skip $dir (source missing)"; continue
    fi
    mkdir -p "papers/$dir"
    rsync -a --delete "$BLOG/landing/papers/$dir/" "papers/$dir/" \
        --exclude='*.aux' --exclude='*.log' --exclude='*.out' --exclude='*.xdv' --exclude='*.bbl' --exclude='*.blg' \
        --exclude='*.sty' --exclude='*.md' --exclude='.claude'
done
# Standalone papers (.tex + .pdf) and deployed dir-paper PDFs.
for f in h_3_O-measure-2026 born-fisher-2026 theorem-a-proof theorem-a-lemmas lipschitz-stability \
         qm-from-self-modeling-2026 radical-relativity-2026 sm-from-self-modeling-2026; do
    cp "$BLOG/landing/papers/${f}.tex" papers/ 2>/dev/null || true
    cp "$BLOG/landing/papers/${f}.pdf" papers/ 2>/dev/null || true
done

echo "Syncing derivations..."
rsync -a --delete "$GPD/derivations/" derivations/ --include='*.md' --exclude='*'

echo "Syncing verification code..."
rsync -a --delete "$GPD/code/" verification/ --include='*.py' --exclude='*'

echo "Syncing experiment code..."
if [ -d "$BLOG/research/self-modeling-constants/code" ]; then
    rsync -a "$BLOG/research/self-modeling-constants/code/" experiments/code/ \
        --include='*.py' --include='requirements.txt' --exclude='*'
fi
cp "$BLOG/research/self-modeling-constants/EPISTEMIC_POKER.md" experiments/ 2>/dev/null || true

echo "Done. Review changes with: git diff --stat"
