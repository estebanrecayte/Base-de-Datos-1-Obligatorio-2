--Para todos los partidos del año corriente hacer una consulta que retorne código y nombre del equipo local, sus
--goles, código y nombre del equipo visitante, sus goles y la fecha del partido, debe utilizar alias para los campos
--para respetar el siguiente resultado:

select p.codEquipo_local as 'CodEquipoLocal', el.nomEquipo as 'NomEquipoLocal',p.GL as 'GolesLocal', p.codEquipo_visita as 'CodEquipoVisita', ev.nomEquipo as 'NomEquipoVisita', p.GV as 'GolesVisita',p.fecha as 'Fecha'
from Partidos p
inner join Equipos el on p.codEquipo_local= el.codEquipo
inner join Equipos ev on p.codEquipo_visita= ev.codEquipo

--Para cada equipo en cuyo nombre aparece la palabra “FC”, mostrar su código, nombre, cantidad de partidos
--jugados de local, cantidad de goles marcados en dichos partidos y la fecha del último partido de local, ordene los
--resultados por goles de mayor a menor, debe respetar el siguiente resultado: 

select e.codEquipo as 'codEquipo', e.nomEquipo as 'nomEquipo', count(p.codEquipo_local) as 'CantPartidosLocal', sum(p.GL) as 'GolesLocal', max(p.fecha) as 'FechaUltimoPartido'
from Equipos e
inner join Partidos p on e.codEquipo = p.codEquipo_local
where e.nomEquipo like '%FC%'
group by e.codEquipo, e.nomEquipo, p.GL
order by p.GL desc

--Mostrar la tabla de goleadores ordenada de mayor a menor, solo incluir aquellos jugadores que marcaron al menos
--un gol, debe respetar el siguiente formato: 

select j.carnJug as 'carnJug', j.nomJug as 'nomJug', sum(d.cntGoles) as 'Goles'
from Jugadores j
inner join Detalles d on j.carnJug = d.carnJug
group by j.carnJug, j.nomJug, d.cntGoles
having sum(d.cntGoles) >= 1

--Para cada árbitro que arbitró partidos, mostrar su cédula, nombre, apellido, cantidad de tarjetas amarillas y cantidad
--de tarjetas rojas sacadas, solo incluir los árbitros que sacaron por lo menos una tarjeta roja, debe respetar el
--siguiente formato: 

select a.ciArbitro as 'ciArbitro', a.nomArbitro as 'nomArbitro', sum(d.cntAmarillas) as 'CantidadAmarillas', sum(d.cntRojas) as 'CantidadRojas'
from Arbitros a
inner join Formularios f on a.ciArbitro = f.ciArbitro
inner join Detalles d on f.numForm = d.numForm
group by a.ciArbitro,a.nomArbitro
having sum(d.cntRojas)>=1

--Mostrar cedula, nombre y apellido de los jugadores amateur que juegan en equipos de camiseta que tienen color
--verde, jugaron partidos los primeros 10 días de enero de 2023 en canchas de mas de 1500 localidades, filtrar
--resultados repetidos y ordenar por apellido del jugador, la salida debe respetar el siguiente formato: 

select distinct j.ciJug as 'ciJug', j.nomJug as 'nomJug', j.apeJug as 'apeJug'
from Jugadores j
inner join Partidos p on j.codEquipo = p.codEquipo_local OR j.codEquipo = p.codEquipo_visita
inner join Equipos e on j.codEquipo = e.codEquipo
inner join Canchas c on p.nomCancha = c.nomCancha
where j.tipoJug='Amateur' and e.colorEquipo='Verde' and p.fecha <= '2023-01-10' and c.capCancha > 1500
order by j.apeJug

-- Para las canchas donde se jugaron entre 9 y 15 partidos, mostrar su nombre, la capacidad y la cantidad de partidos
--jugados, la consulta debe respetar el siguiente formato: 

select c.nomCancha as 'nomCancha', c.capCancha as 'capCancha', count(p.fecha) as 'CantPartidos' 
from Canchas c
inner join Partidos p on c.nomCancha = p.nomCancha
group by c.nomCancha,c.capCancha
having count(p.fecha) between 9 and 15

--7. Mostrar los nombres de los equipos de región sur o de región norte que jugaron mas de 2 partidos en canchas de
--más de 2000 espectadores (tener en cuenta cuando fue local y cuando fue visitante). 

select e.nomEquipo as 'NombreEquipo'
from Equipos e
inner join Partidos p on e.codEquipo = p.codEquipo_local OR e.codEquipo = p.codEquipo_visita
inner join Canchas c on p.nomCancha = c.nomCancha 
where e.regionEquipo in ('Sur','Norte') and c.capCancha > 2000
group by e.nomEquipo
having count(p.fecha) > 2

--Mostrar todos los datos del árbitro que sacó mas tarjetas rojas, la consulta debe respetar el siguiente formato: 

select top 1 a.ciArbitro, a.nomArbitro, a.apelArbitro, a.celularArbitro, a.dirArbitro, a.mailArbitro, sum(d.cntRojas) as 'CantRojas'
from Arbitros a
inner join Formularios f on a.ciArbitro = f.ciArbitro
inner join Detalles d on f.numForm = d.numForm
group by a.ciArbitro, a.nomArbitro, a.celularArbitro, a.apelArbitro, a.dirArbitro, a.mailArbitro
order by CantRojas desc

--Agregar un campo “FundaLiga” de largo 1 carácter en la tabla Equipo, ponerle el valor “S” a todos los equipos
--que tienen mas de 50 años de fundados.

alter table Equipos
add FundaLiga varchar(1)

update Equipos
set FundaLiga = 'S'
where YEAR(GETDATE()) - YEAR(fundacionEquipo) > 50

select *
from Equipos

-- Borrar todos los jugadores profesionales que no tienen fecha de vencimiento en su carnet de salud. select *from Jugadoresdeletefrom Jugadoreswhere tipoJug = 'Profesional' and carnetVto is NULL-- al estar vinculados con la tabla Detalles, deberia primero seleccionar los jugadores de la tabla detalles que estan involucrados y luego borrarlos de la tabla padre Jugadores:-- esta consulta la saque de chatgptselect *from detallesdelete from Detalles
where carnJug IN (
    select carnJug
    from Jugadores
    where tipoJug = 'Profesional' AND carnetVto IS NULL
)
