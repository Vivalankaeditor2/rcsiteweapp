package com.rev_creations.rcsite.repository;
import com.rev_creations.rcsite.entity.GeoLocation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GeoLocationRepository extends JpaRepository<GeoLocation, Long> {
}
