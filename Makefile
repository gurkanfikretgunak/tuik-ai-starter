.PHONY: dev test lint doctor
dev:
	@echo "api:  cd services/api && go run ./cmd/api"
	@echo "web:  cd apps/web && npm run dev"
	@echo "calc: cd compute && python -m pytest"
test:
	cd services/api && go test ./...
	cd compute && python -m pytest -q
lint:
	cd services/api && go vet ./...
	cd compute && python -m ruff check . || true
doctor:
	bash scripts/doctor.sh

.PHONY: audit audit-list test-hooks
audit:           ## bağımlılık zafiyet taraması (yeni bulguları kayda ekler)
	python3 scripts/vuln-track.py scan --write
audit-list:      ## açık zafiyetler + hook bulguları
	python3 scripts/vuln-track.py list
	python3 scripts/vuln-track.py hooks
test-hooks:      ## hook davranış testleri
	bash scripts/test-hooks.sh

.PHONY: sync-cursor
sync-cursor:    ## .claude -> .cursor eşitle
	python3 scripts/sync-cursor.py
