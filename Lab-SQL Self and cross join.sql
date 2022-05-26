use sakila;

-- 1. 
-- Get all pairs of actors that worked together.
-- Self Join
select distinct fafirst.film_id, fafirst.actor_id, afirst.first_name, afirst.last_name, fasecond.actor_id, asecond.first_name, asecond.last_name 
from sakila.film_actor as fafirst
join sakila.film_actor as fasecond on fasecond.film_id=fafirst.film_id and fafirst.actor_id > fasecond.actor_id
join sakila.actor as afirst on afirst.actor_id = fafirst.actor_id
join sakila.actor as asecond on asecond.actor_id = fasecond.actor_id
order by fafirst.film_id;
-- or
select distinct fafirst.film_id, fafirst.actor_id, afirst.first_name, afirst.last_name, fasecond.actor_id, asecond.first_name, asecond.last_name 
from sakila.film_actor as fafirst
join sakila.film_actor as fasecond on fasecond.film_id=fafirst.film_id
join sakila.actor as afirst on afirst.actor_id = fafirst.actor_id
join sakila.actor as asecond on asecond.actor_id = fasecond.actor_id
where afirst.actor_id > asecond.actor_id
order by fafirst.film_id;
-- or if we would like to have the pair in the opposite order as well, we will have double number of results
select fafirst.film_id, fafirst.actor_id, afirst.first_name, afirst.last_name, fasecond.actor_id, asecond.first_name, asecond.last_name 
from sakila.film_actor as fafirst
cross join sakila.film_actor as fasecond on fasecond.film_id=fafirst.film_id
join sakila.actor as afirst on afirst.actor_id = fafirst.actor_id
join sakila.actor as asecond on asecond.actor_id = fasecond.actor_id
where afirst.actor_id <> asecond.actor_id
order by fafirst.film_id;

-- 2. 
-- Get all pairs of customers that have rented the same film more than 3 times.
select * from sakila.rental;
-- if we make the query there is no result because there is no pair of customers that have rented the same film more than 3 times
select sub1.customer_id, sub1.first_name, sub1.last_name, sub2.customer_id, sub2.first_name, sub2.last_name,  sub1.film_id, sub1.number_of_being_rented from (
	select customer_id, first_name, last_name, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
    join customer as r using(customer_id)
	group by customer_id, film_id
	having count(rental_id) > 3
	order by customer_id, film_id
    )sub1
join (
	select customer_id, first_name, last_name, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
    join customer as r using(customer_id)
	group by customer_id,film_id
	having count(rental_id) > 3
	order by customer_id, film_id
    )sub2
	on sub1.film_id = sub2.film_id and sub1.customer_id <> sub2.customer_id;
-- or
select sub1.customer_id, sub2.customer_id, sub1.film_id, sub1.number_of_being_rented from (
	select customer_id, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
	group by customer_id, film_id
	having count(rental_id) > 3
	order by customer_id, film_id
    )sub1
join (
	select customer_id, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
	group by customer_id,film_id
	having count(rental_id) > 3
	order by customer_id, film_id
    )sub2
	on sub1.film_id = sub2.film_id and sub1.customer_id <> sub2.customer_id;

-- if we would like to get all pairs of customers that have rented the same film more than 1 time then 
select sub1.customer_id, sub1.first_name, sub1.last_name, sub2.customer_id, sub2.first_name, sub2.last_name,  sub1.film_id, sub1.number_of_being_rented from (
	select customer_id, first_name, last_name, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
    join customer as r using(customer_id)
	group by customer_id, film_id
	having count(rental_id) > 1
	order by customer_id, film_id
    )sub1
join (
	select customer_id, first_name, last_name, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
    join customer as r using(customer_id)
	group by customer_id,film_id
	having count(rental_id) > 1
	order by customer_id, film_id
    )sub2
	on sub1.film_id = sub2.film_id and sub1.customer_id <> sub2.customer_id;
-- or
select sub1.customer_id, sub2.customer_id, sub1.film_id, sub1.number_of_being_rented from (
	select customer_id, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
	group by customer_id, film_id
	having count(rental_id) > 1
	order by customer_id, film_id
    )sub1
join (
	select customer_id, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
	group by customer_id,film_id
	having count(rental_id) > 1
	order by customer_id, film_id
    )sub2
	on sub1.film_id = sub2.film_id and sub1.customer_id <> sub2.customer_id;
    
    -- or if we would like to have the pair only in one direction order, we will have half number of results, for instance we get the 
    -- pair of customer_ids 6-275 but we don't get the pair of customer_ids 275-6
    select sub1.customer_id, sub1.first_name, sub1.last_name, sub2.customer_id, sub2.first_name, sub2.last_name,  sub1.film_id, sub1.number_of_being_rented from (
	select customer_id, first_name, last_name, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
    join customer as r using(customer_id)
	group by customer_id, film_id
	having count(rental_id) > 1
	order by customer_id, film_id
    )sub1
join (
	select customer_id, first_name, last_name, film_id, count(rental_id) as number_of_being_rented from sakila.rental
	left join inventory as i using(inventory_id)
    join customer as r using(customer_id)
	group by customer_id,film_id
	having count(rental_id) > 1
	order by customer_id, film_id
    )sub2
	on sub1.film_id = sub2.film_id and sub1.customer_id > sub2.customer_id;

-- 3. 
-- Get all possible pairs of actors and films.
select distinct fa.film_id from sakila.film_actor as fa;
select distinct a.actor_id from sakila.actor as a;
-- all possible pairs of actors and films, for instance the first pair is the actress Penelope Guiness-with the film Academy Dinosaur
-- the second pair is the actress Penelope Guiness-with the film Age Goldfinger etc.

select * from (
	select distinct a.actor_id, a.first_name, a.last_name from sakila.actor as a
) sub1
cross join (
	select distinct fa.film_id, f.title from sakila.film_actor as fa
    join sakila.film as f on f.film_id=fa.film_id
) sub2
order by actor_id, film_id;