install-dependencies:
	pipenv install

run: install-dependencies scan
	pipenv run python main.py

scan:
	pipenv run python scan.py

plan:
	terraform plan

deploy:
	terraform apply -auto-approve
