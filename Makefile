lint:
	find . -name \*.yml -exec ansible-lint {} \; 

# Gera o playbook do primeiro exemplo de webserver.yml
webserver-0.yml: webserver.yml
	head -18 $< > $@
TRASH += webserver-0.yml

clean:
	$(RM) $(TRASH)
