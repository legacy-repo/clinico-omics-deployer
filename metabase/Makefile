build:
	echo "Generating Environment Variables..."
	@cp -f config/metabase_database.env .env

clean:
	rm -rf ./data/sysdata
	rm -rf ./data/userdata/mysql/*
	rm -rf ./data/userdata/mysql-log/*