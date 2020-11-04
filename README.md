# reorga_tablas
Procedimiento Construido con PLSQL que permite reorganizar una tabla fragmentada y sus dependientes
Requiere tener las estadisticas lo  más actualizadas posibles.
Las tablas a defragmentar pueden ser calculadas con el procedimiento en el proyecto github: 
Los indices  son marcados UNUSABLES por el proceso, pero el mismo se encarga de ponerlos online,  requiere que los indices sean del mismo owner de la tabla.
Las estadisticas de la tabla son recalculadas 
