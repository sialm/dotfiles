## how to plat_core


1. spin up platform on vagrant 
1. spin up devdb on opctl
1. edit database file to point to 10.0.2.2
1. run unit tests
1. run migrations 
1. run fixtures
	1. comment out banks.php:21-62 + manila_system_data.php:3579-3602
1. run watchlist integration tests
1. spin up cxcore on vagrant 
1. add overrides to point to devdb

http://remittancecatalog-prod-us-west-1.remitly.com
http://remittancecatalog-prod-us-west-1.remitly.com/