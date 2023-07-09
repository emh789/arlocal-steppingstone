# stepping stone migration

- Local:
  - clone git
  - copy database file
  - copy existing storage
  - run migration
  - look for errors

- remote:
  - NEEDS NEW RUBY/RAILS. Only proceed when ready on local machine.
    - Consider using a new VM not ubuntu.
  - clone new git
  - copy local (migrated) database file
  - copy exiting storage
  - look for errors


- steps
  - git pull #{arlocal} 55191e8d5a040bd079c557647cc7866f2a48260d
  - rails db:migrate VERSION=20230405010631
  - rails db:migrate VERSION=20230521021626
