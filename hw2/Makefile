.PHONY: run clean test

run:
	cargo run --release
	python plot.py

clean:
	cargo clean
	rm _table.typ
	rm data.csv
	rm runtime.png
	rm runtime-log.png
	rm operations.png
	rm operations-log.png

test:
	cargo test
