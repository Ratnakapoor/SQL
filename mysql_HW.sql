use sakila

/*Display the first and last names of all actors from the table `actor */
select first_name, last_name from actor

/*Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. */
select CONCAT ( upper(first_name), " " , upper(last_name) )  as Name from actor 

/*find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe*/
select actor_id, first_name, last_name from actor where first_name = "Joe"

/*Find all actors whose last name contain the letters `GEN`:*/
select first_name, last_name from actor where last_name like "%GEN%"

/*Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:*/
select first_name, last_name from actor where last_name like "%IN%" order by Last_name , first_name

/*Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China*/
select country_id, country from country where country in ("Afghanistan", "Bangladesh", "China")

/*create a column in the table `actor` named `description` and use the data type `BLOB*/
ALTER TABLE actor add ( Actor_Description blob )

/*Delete the `description` column*/
ALTER TABLE actor DROP COLUMN Actor_Description

/*List the last names of actors, as well as how many actors have that last name.*/
select last_name , count(last_name) from actor group by last_name

/*List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors*/
select last_name , count(last_name) lcount from actor group by last_name having lcount >= 2

/*The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. fix the record.*/
update actor
set first_name = 'HARPO'  where first_name = 'GROUCHO' and last_name = "WILLIAMS"


/*Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`*/
select a.first_name, a.last_name , b.address, b.address2 from staff a join address b using ( address_id)

/*Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.*/
select a.first_name, a.last_name, sum(b.amount) from staff a  join payment using (staff_id ) 
where b.payment_date between  '2004-12-31' and '2006-01-01'
group by a.staff_id


/*List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.*/
select title ,  count(actor_id) from film a, film_actor b   where a.film_id = b.film_id

/*How many copies of the film `Hunchback Impossible` exist in the inventory system*/
select count(*) from inventory where film_id in 
( select film_id from film where title like 'HUNCH%' ) 

/*Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
List the customers alphabetically by last name */
select first_name, last_name , sum(amount)   from customer a join payment b using ( customer_id) 
group by a.customer_id
order by a.last_name


/*The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of 
movies starting with the letters `K` and `Q` whose language is English */
select * from film where ( title like 'K%' ) or ( title like 'Q%' ) 
and language_id in ( select language_id from language where name like 'English' ) 


/*Use subqueries to display all actors who appear in the film `Alone Trip`.*/
select first_name, last_name from actor a where actor_id in 
( select actor_id from film_actor where  film_id in ( select film_id from film where  title  = 'Alone Trip' ))


/* You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of 
all Canadian customers. Use joins to retrieve this information. */
select first_name, last_name, email from customer where address_id in ( select city_id from address  where city_id in ( 
select country_id from city where country_id in ( select country_id from country where country = 'Canada' ))) 



/*  Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as _family_ films.  */
select titles from film where rating in ('PG','G','PG-13')

/*Display the most frequently rented movies in descending order. */
select title , count(*) from film a, inventory b, rental c
where a.film_id = b.film_id
and b.inventory_id = c.inventory_id
group by title

select title from film where film_id in ( 
( select film_id , count(*) cnt from rental join inventory using ( inventory_id )
  group by film_id order by cnt desc))


/*Write a query to display how much business, in dollars, each store brought in */
select a.store_id , sum(c.amount) from inventory a , rental b , payment c 
where a.inventory_id = b.inventory_id
and b.customer_id = c.customer_id
group by a.store_id 


/*List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, 
film_category, inventory, payment, and rental.) */
CREATE VIEW Revenue AS
select a.film_id  filmid, sum(c.amount) revenue from inventory a , rental b , payment c 
where a.inventory_id = b.inventory_id
and b.customer_id = c.customer_id
group by a.film_id 

Create view  Category_revenue as
select a.category_id , a.name category, sum(c.revenue) gross_revenue from category a, film_category b, Revenue c
where a.category_id = b.category_id 
and b.film_id = c.filmid
group by a.category_id , a.name


select category , gross_revenue  from Category_revenue 
order by gross_revenue desc limit 5
 


/*In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
 Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. */
 

/*How would you display the view that you created in 8a */
describe Category_revenue
select * from Category_revenue


/* You find that you no longer need the view `top_five_genres`. Write a query to delete it. */
Drop View if exists Catgory_revenue








