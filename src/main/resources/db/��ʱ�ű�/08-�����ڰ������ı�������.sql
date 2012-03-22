-- 此sql已于2012-03-19 18:00执行
--更新在案车辆的报废日期为经济合同的结束日期
CREATE OR REPLACE FUNCTION updateNormalCarScrapDate(cid IN integer) RETURNS varchar AS $$
DECLARE
	--定义变量
	 nothings varchar(4000);
BEGIN
	update bs_car set scrap_date = (
			select bc.end_date from bs_car c 
				inner join bs_car_contract cc on cc.car_id = c.id
				inner join bs_contract bc on bc.id=cc.contract_id
				inner join bs_contract_charger bcc on bcc.id=bc.id
				where c.status_ = 0 and bc.type_ = 2 and bc.status_ = 0 and c.id=cid 
				order by bc.file_date desc limit 1
					)where id = cid;
	return nothings;
END;
$$ LANGUAGE plpgsql;

select updateNormalCarScrapDate(id) from bs_car where id in(
			select c.id from bs_car c 
				inner join bs_car_contract cc on cc.car_id = c.id
				inner join bs_contract bc on bc.id=cc.contract_id
				inner join bs_contract_charger bcc on bcc.id=bc.id
				where c.status_ = 0 and bc.type_ = 2 and bc.status_ = 0 
							);