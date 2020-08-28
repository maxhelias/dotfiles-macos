#!/bin/sh

# Docker Symfony
git clone https://github.com/dunglas/symfony-docker.git $HOME/www/project/symfony-docker

# Symfony Flex
git clone https://github.com/maxhelias/flex $HOME/www/contrib/symfony/flex
cd $HOME/www/contrib/symfony/flex
git remote add upstream https://github.com/symfony/flex

cd $HOME
