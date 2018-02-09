          set @tagid =(select location_tag_id from location_tag where name='Admission Location');
          set @locationid =(select location_id from location where name ='CHK');
          insert into location_tag_map (location_id,location_tag_id) values (@locationid,@tagid);
