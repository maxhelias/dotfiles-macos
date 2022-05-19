#!/bin/sh

# Docker Symfony
git clone https://github.com/dunglas/symfony-docker.git $HOME/www/opensource/symfony-docker

# Symfony Flex
git clone https://github.com/maxhelias/flex $HOME/www/opensource/symfony/flex
cd $HOME/www/opensource/symfony/flex
git remote add upstream https://github.com/symfony/flex

cd $HOME
