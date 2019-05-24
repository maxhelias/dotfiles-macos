#!/bin/sh

# Symfony Docker
git clone https://github.com/maxhelias/symfony-docker $HOME/www/contrib/symfony-docker
cd $HOME/www/contrib/symfony-docker
git remote add upstream https://github.com/dunglas/symfony-docker

# Symfony Flex
git clone https://github.com/maxhelias/flex $HOME/www/contrib/flex
cd $HOME/www/contrib/flex
git remote add upstream https://github.com/symfony/flex

cd $HOME