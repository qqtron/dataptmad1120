-- CHALLENGE 1 --
-- Step 1 --
SELECT titleauthor.title_id AS 'Title ID',
       titleauthor.au_id AS 'Author ID',
       titles.advance * titleauthor.royaltyper / 100 AS 'Advance',
       titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS 'Royalty'
FROM titles
INNER JOIN sales ON sales.title_id = titles.title_id
INNER JOIN titleauthor ON titleauthor.title_id = sales.title_id
ORDER BY titleauthor.title_id;
-- Step 2 --
SELECT step_1.title_id AS 'Title ID',
       step_1.au_id AS 'Author ID',
       --step_1.Advance,
       SUM(step_1.Royalty) AS Royalties
FROM
  (SELECT titleauthor.title_id,
          titleauthor.au_id,
          titles.advance * titleauthor.royaltyper / 100 AS Advance,
          titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS Royalty
   FROM titles
   INNER JOIN sales ON sales.title_id = titles.title_id
   INNER JOIN titleauthor ON titleauthor.title_id = sales.title_id) step_1
GROUP BY step_1.title_id,
         step_1.au_id
ORDER BY step_1.title_id;
-- Step 3 --
SELECT step_2.au_id AS 'Author ID',
       ROUND(SUM(step_2.Advance + step_2.Royalties), 2) AS Profits
FROM
  (SELECT step_1.title_id,
          step_1.au_id,
          step_1.Advance,
          SUM(step_1.Royalty) AS Royalties
   FROM
     (SELECT titleauthor.title_id,
             titleauthor.au_id,
             titles.advance * titleauthor.royaltyper / 100 AS Advance,
             titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS Royalty
      FROM titles
      INNER JOIN sales ON sales.title_id = titles.title_id
      INNER JOIN titleauthor ON titleauthor.title_id = sales.title_id) step_1
   GROUP BY step_1.title_id,
            step_1.au_id) step_2
GROUP BY step_2.au_id
ORDER BY Profits DESC
LIMIT 3;



-- Challenge 2 -

SELECT AuthorID, ROUND(SUM(RoyaltyPerTitleAndAuthor + Advance_Title_Author)) AS Profits
FROM (
    SELECT AuthorID, TitleID, SUM(Royalty_by_Sale) AS RoyaltyPerTitleAndAuthor, Advance_Title_Author
    FROM (
      SELECT titleauthor.au_id AS AuthorID, sales.title_id AS TitleID,
      ((titles.price * sales.qty) * (titles.royalty / 100) * (titleauthor.royaltyper / 100)) AS Royalty_by_Sale,
      (titles.advance * (titleauthor.royaltyper / 100)) AS Advance_Title_Author
      FROM sales 
      INNER JOIN titles ON sales.title_id = titles.title_id
      INNER JOIN titleauthor ON titles.title_id = titleauthor.title_id
    ) royalties_per_sale
    GROUP BY TitleID, AuthorID, Advance_Title_Author
    ) royalties_and_advance_per_title_and_author
GROUP BY AuthorID
ORDER BY Profits desc
LIMIT 3;


-- Challenge 3 -

SELECT *
INTO TABLE most_profiting_authors
FROM profits
ORDER BY Profits desc
LIMIT 3;

