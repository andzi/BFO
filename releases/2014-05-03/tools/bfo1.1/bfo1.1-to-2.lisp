(defparameter *region-subset-classes* 
  (eval-uri-reader-macro
   '((!snap:ZeroDimensionalRegion !obo:BFO_0000018 :region) 
    (!snap:ThreeDimensionalRegion !obo:BFO_0000028 :region) 
    (!span:ScatteredSpatiotemporalRegion !obo:BFO_0000010 :region) 
    (!span:SpatiotemporalInstant !obo:BFO_0000012 :region) 
    (!span:SpatiotemporalRegion !obo:BFO_0000011 :region) 
    (!snap:OneDimensionalRegion !obo:BFO_0000026  :region) 
    (!span:SpatiotemporalInterval !obo:BFO_0000036 :region) 
    (!snap:TwoDimensionalRegion !obo:BFO_0000009  :region) 
    (!span:ConnectedSpatiotemporalRegion !obo:BFO_0000013  :region)
    (!snap:SpatialRegion !obo:BFO_0000006  :region)
    (!span:SpatioTemporalRegion !obo:BFO_0000009  :region))))

(defparameter *obsolete-classes*
  (eval-uri-reader-macro '(!span:ProcessualContext !span:ProcessualEntity)))

(defparameter *granularity-subset-classes* 
  (eval-uri-reader-macro '(!snap:Object !snap:FiatObjectPart !snap:ObjectAggregate !span:ProcessAggregate !span:FiatProcessPart)))

(defparameter *bfo-id-map*
  (let ((table (make-hash-table)))
    (loop for (old new) in 
	 (eval-uri-reader-macro'((!span:TemporalInstant !obo:BFO_0000021) 
	   (!snap:Quality !obo:BFO_0000019) 
	   (!span:ScatteredTemporalRegion !obo:BFO_0000032) 
	   (!snap:ZeroDimensionalRegion !obo:BFO_0000018 :region) 
	   (!snap:ThreeDimensionalRegion !obo:BFO_0000028 :region) 
	   (!snap:Role !obo:BFO_0000023) 
	   (!snap:Object !obo:BFO_0000030) 
	   (!snap:GenericallyDependentContinuant !obo:BFO_0000031) 
	   (!snap:RealizableEntity !obo:BFO_0000017) 
	   (!snap:FiatObjectPart !obo:BFO_0000024) 
	   (!span:ScatteredSpatiotemporalRegion !obo:BFO_0000010 :region) 
	   (!snap:Disposition !obo:BFO_0000016) 
	   (!span:ProcessAggregate !obo:BFO_0000014) 
	   (!span:SpatiotemporalInstant !obo:BFO_0000012 :region) 
	   (!snap:Site !obo:BFO_0000029) 
	   (!snap:ObjectBoundary !obo:BFO_0000025) 
	   (!span:ConnectedTemporalRegion !obo:BFO_0000022) 
	   (!span:SpatiotemporalRegion !obo:BFO_0000011 :region) 
	   (!span:ProcessBoundary !obo:BFO_0000035) 
	   (!snap:OneDimensionalRegion !obo:BFO_0000026  :region) 
	   (!snap:MaterialEntity !obo:BFO_0000040) 
	   (!span:ProcessualContext !obo:BFO_0000037) 
	   (!span:SpatiotemporalInterval !obo:BFO_0000036 :region) 
	   (!snap:ObjectAggregate !obo:BFO_0000027) 
	   (!snap:TwoDimensionalRegion !obo:BFO_0000009  :region) 
	   (!span:ProcessualEntity !obo:BFO_0000015) 
	   (!span:TemporalInterval !obo:BFO_0000038) 
	   (!snap:Function !obo:BFO_0000034) 
	   (!span:FiatProcessPart !obo:BFO_0000033) 
	   (!snap:SpecificallyDependentContinuant !obo:BFO_0000020) 
	   (!span:ConnectedSpatiotemporalRegion !obo:BFO_0000013  :region)
	   (!bfo:Entity !obo:BFO_0000001)
	   (!snap:Continuant !obo:BFO_0000002)
	   (!span:Occurrent !obo:BFO_0000003)
	   (!snap:IndependentContinuant !obo:BFO_0000004)
	   (!snap:DependentContinuant !obo:BFO_0000005)
	   (!snap:SpatialRegion !obo:BFO_0000006  :region)
	   (!span:Process !obo:BFO_0000007)
	   (!span:TemporalRegion !obo:BFO_0000008)
	   (!span:SpatioTemporalRegion !obo:BFO_0000009  :region)))
	 do (setf (gethash old table) new))
    table))

(defun id-for-bfo-class (class)
  (or (gethash class *bfo-id-map*)
      (error "No id for ~a" class)))

(defun bfo11->2 (&key (core? t) subset
		 (dest "~/repos/bfo/trunk/src/ontology/bfo2-classes.owl")
		 (uri "http://purl.obolibrary.org/obo/bfo/core-classes.owl"))
  (let ((bfo (load-ontology "~/repos/bfo/trunk/bfo.owl")))
    (with-ontology bfonew (:collecting t :about uri
				    :ontology-properties
				    (and core? (loop for (ontprop val) in (sparql
									   '(:select (?p ?v) ()
									     (!<http://www.ifomis.org/bfo/1.1> ?p ?v)
									     (:filter (and (not (equal ?p !dc:creator)) (not (equal ?p !owl:versionInfo))))

									     )
									   :kb bfo :use-reasoner :none)
						  collect
						    `(annotation ,ontprop ,val))))
	((let* ((definition !obo:IAO_0000115)
		(alternative-term !obo:IAO_0000118)
		(example-of-usage !obo:IAO_0000112)
		(editor-preferred-label !obo:IAO_0000111)
		(editor-note  !obo:IAO_0000116)
		)
	   (flet ((@en (s) (format nil "~a@en" (substitute #\space #\_ s)))
		  (props-for (thing prop)
		    (sparql `(:select (?value) () (,thing ,prop ?value)) :kb bfo :use-reasoner :none :flatten t)))
	     (as `(annotation-assertion !rdfs:label ,alternative-term ,(@en "alternative term"))
		 `(annotation-assertion !rdfs:label ,example-of-usage ,(@en "example of usage"))
		 `(annotation-assertion !rdfs:label ,editor-preferred-label ,(@en "editor preferred term"))
		 `(annotation-assertion !rdfs:label ,definition ,(@en "definition"))
		 `(annotation-assertion !rdfs:label ,editor-note ,(@en "editor note"))
		 `(declaration (annotation-property ,example-of-usage))
		 `(declaration (annotation-property ,editor-preferred-label))
		 `(declaration (annotation-property ,alternative-term))
		 `(declaration (annotation-property ,definition))
		 `(declaration (annotation-property ,editor-note))
		 `(declaration (annotation-property !dc:source))
		 `(declaration (annotation-property !dc:publisher))
		 `(declaration (annotation-property !dc:contributor))
		 `(declaration (annotation-property !dc:creator))
		 
		 )
	     (loop for (ontprop val) in (sparql '(:select (?p ?v) () (!obo:bfo.owl ?p ?v)) :kb bfo :use-reasoner :none)
		do
		(as `(declaration (annotation-property ,ontprop)))
		(as `(annotation-assertion ,ontprop !obo:bfo.owl ,val)))

	     (loop for (class parent label doc)  in
		  (sparql '(:select (?class ?parent ?label ?documentation) () (?class !rdf:type !owl:Class) 
			    (:optional (?class !rdfs:subClassOf ?parent) (:filter (not (isblank ?parent))))
			    (:optional (?class !skos:definition ?documentation))
			    (?class !skos:prefLabel ?label)
			    (:filter (not (isblank ?class)))
			    )
			  :kb bfo :use-reasoner :none)
		  for classid = (id-for-bfo-class class)
		  for parentid = (and parent (id-for-bfo-class parent))
		  when (cond (core?
			      (and 
			       (not (assoc class *region-subset-classes*))
			       (not (member class *obsolete-classes*))
			       (not (member class *granularity-subset-classes*))))
			     ((and (not core?) (eq subset :region))
			      (assoc class *region-subset-classes*))
			     ((and (not core?) (eq subset :granularity))
			      (member class *granularity-subset-classes*)))
		  do
		  (as `(declaration (class ,classid)))
		  (cond ((eq class !snap:Function)
			 (as `(subclass-of ,classid ,(id-for-bfo-class !snap:Disposition))))
			((or (eq class !span:Process) (eq class !span:ProcessBoundary))
			 (as `(subclass-of ,classid ,(id-for-bfo-class !span:Occurrent))))
			((or (eq class !span:FiatProcessPart) (eq class !span:ProcessAggregate))
			 (as `(subclass-of ,classid ,(id-for-bfo-class !span:Process))))
			((or (eq class !snap:FiatObjectPart) (eq class !snap:ObjectAggregate) (eq class !snap:Object))
			 (as `(subclass-of ,classid ,(id-for-bfo-class !snap:MaterialEntity))))
			(parent (as `(subclass-of ,classid ,parentid))
				(as `(declaration (parent ,parentid)))))
		  (when doc
		    (as `(annotation-assertion ,definition ,classid ,(@en (#"replaceAll" doc "\\[.*?\\]" "")))))
		  (as
		   `(annotation-assertion !rdfs:label ,classid ,(@en label))
		   `(annotation-assertion ,editor-preferred-label ,classid ,(@en label)))
		  (loop for example in (props-for class !skos:example) 
		     do (as `(annotation-assertion ,example-of-usage ,classid ,(@en example))))
		  (loop for syn in (props-for class !skos:altLabel)
		     do (as `(annotation-assertion ,alternative-term ,classid ,(@en syn))))
		  (loop for com in (props-for class !rdfs:comment)
		     do (as `(annotation-assertion ,editor-note ,classid ,(@en com))))
		  ))))
      (write-rdfxml bfonew dest))))

(bfo11->2)
(bfo11->2 :core? nil :subset :region :dest "~/repos/bfo/trunk/src/ontology/bfo2-regions.owl" :uri "http://purl.obolibrary.org/obo/bfo/region-classes.owl")
(bfo11->2 :core? nil :subset :granularity :dest "~/repos/bfo/trunk/src/ontology/bfo2-granularity.owl" :uri "http://purl.obolibrary.org/obo/bfo/granularity-classes.owl")